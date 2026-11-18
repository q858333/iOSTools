# iOSTools
一些开发时用到的工具

## 3D 模型演示

打开 `Tools/Tools.xcworkspace`，运行后从首页的“3D 模型演示”进入。
可分别选择 RealityKit 和 SceneKit，查看透明背景的 Duck.glb 模型，支持拖动旋转、双指缩放和重置视角。返回演示选择页后点击“返回”可回到工具首页。

- 最低支持 iOS 15.6；GLTFKit2 通过 CocoaPods 固定为 0.5.15。在 `Tools` 目录运行 `pod install`，再打开 workspace。
- GLTFKit2 使用 `:path => 'LocalPods/GLTFKit2'` 本地 Pod，目录内包含 podspec、官方 XCFramework 和许可证；安装时不下载 GLTFKit2，无需配置 SPM。该目录需随项目一同保存。
- 源码和模型资源位于 `Tools/Tools/ThreeD`，保留模型与 GLTFKit2 的许可证。
- 当前项目原有的 WebP 和 libmp3lame 静态库不支持 arm64 模拟器，请使用真机运行完整应用。

# 文档

* [需要添加隐私配置的三方库](https://developer.apple.com/cn/support/third-party-SDK-requirements/)

* [App Store Connect 文档](https://developer.apple.com/cn/help/app-store-connect/manage-in-app-purchases/schedule-price-changes/)

* [隐私配置文档1](https://juejin.cn/post/7347165355586109477)
  
* [隐私配置文档2](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)

* [隐私配置文档3](https://www.6hu.cc/archives/243323.html)

