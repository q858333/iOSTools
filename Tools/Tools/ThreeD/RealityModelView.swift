import UIKit
import RealityKit
import GLTFKit2
import simd

/// 给 Objective-C 页面使用的透明、非 AR 模型视图。
@objc(RealityModelView)
public final class RealityModelView: UIView {
    private let arView = ARView(frame: .zero, cameraMode: .nonAR,
                                automaticallyConfigureSession: false)
    private let modelPivot = Entity()
    private var loadTask: Task<Void, Never>?
    private var yaw: Float = 0
    private var pitch: Float = 0
    private var modelScale: Float = 1

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        arView.backgroundColor = .clear
        arView.isOpaque = false
        arView.environment.background = .color(.clear)
        arView.frame = bounds
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(arView)

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(modelPivot)
        arView.scene.addAnchor(anchor)

        let camera = PerspectiveCamera()
        camera.camera.near = 0.01
        camera.camera.far = 100
        camera.camera.fieldOfViewInDegrees = 45
        camera.look(at: .zero, from: [0, 0.4, 4.2], relativeTo: nil)
        anchor.addChild(camera)

        let keyLight = DirectionalLight()
        keyLight.light.intensity = 2500
        keyLight.look(at: .zero, from: [3, 4, 5], relativeTo: nil)
        anchor.addChild(keyLight)

        let fillLight = DirectionalLight()
        fillLight.light.intensity = 800
        fillLight.look(at: .zero, from: [-3, 1, -2], relativeTo: nil)
        anchor.addChild(fillLight)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(rotateModel(_:)))
        pan.maximumNumberOfTouches = 1
        arView.addGestureRecognizer(pan)
        arView.addGestureRecognizer(UIPinchGestureRecognizer(target: self,
                                                             action: #selector(scaleModel(_:))))
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(frame:)")
    }

    deinit {
        loadTask?.cancel()
    }

    @objc(loadModelWithURL:completion:)
    public func loadModel(url: URL, completion: @escaping (NSError?) -> Void) {
        loadTask?.cancel()
        loadTask = Task { @MainActor [weak self] in
            do {
                let model = try await GLTFRealityKitLoader.load(from: url)
                try Task.checkCancellation()
                guard let self else { return }

                self.removeImportedCameras(from: model)

                // 使用独立容器归一化，保留 GLB 节点本身的变换。
                let container = Entity()
                container.addChild(model)
                let bounds = container.visualBounds(relativeTo: container)
                let extent = max(bounds.extents.x, max(bounds.extents.y, bounds.extents.z))
                if extent > 0 {
                    let scale: Float = 2 / extent
                    container.scale = SIMD3(repeating: scale)
                    container.position = -bounds.center * scale
                }
                for child in Array(self.modelPivot.children) {
                    child.removeFromParent()
                }
                self.modelPivot.addChild(container)
                self.resetCamera()
                completion(nil)
            } catch is CancellationError {
                // 页面释放或重新加载后，不再更新旧页面。
            } catch {
                guard !Task.isCancelled, self != nil else { return }
                completion(error as NSError)
            }
        }
    }

    private func removeImportedCameras(from entity: Entity) {
        // GLB 可能自带相机；它会随模型一起旋转，覆盖页面的固定观察视角。
        // 只移除相机组件，保留该节点上的模型、变换和子节点。
        entity.components.remove(PerspectiveCameraComponent.self)
        for child in entity.children {
            removeImportedCameras(from: child)
        }
    }

    @objc public func resetCamera() {
        yaw = 0
        pitch = 0
        modelScale = 1
        updateTransform()
    }

    @objc private func rotateModel(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: arView)
        yaw += Float(translation.x) * 0.01
        pitch = min(.pi / 2, max(-.pi / 2, pitch + Float(translation.y) * 0.01))
        gesture.setTranslation(.zero, in: arView)
        updateTransform()
    }

    @objc private func scaleModel(_ gesture: UIPinchGestureRecognizer) {
        modelScale = min(2.5, max(0.4, modelScale * Float(gesture.scale)))
        gesture.scale = 1
        updateTransform()
    }

    private func updateTransform() {
        modelPivot.orientation = simd_quatf(angle: pitch, axis: [1, 0, 0])
            * simd_quatf(angle: yaw, axis: [0, 1, 0])
        modelPivot.scale = SIMD3(repeating: modelScale)
    }
}
