Pod::Spec.new do |s|
  s.name = 'GLTFKit2'
  s.version = '0.5.15'
  s.summary = 'glTF model loading for SceneKit and RealityKit.'
  s.homepage = 'https://github.com/warrenm/GLTFKit2'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = 'Warren Moore'
  # 官方发行包来源；使用 :path 时直接读取本地框架，不下载 source。
  s.source = {
    :http => "https://github.com/warrenm/GLTFKit2/releases/download/#{s.version}/GLTFKit2.xcframework.zip",
    :sha256 => '9d0c338282acce4986494aa02a5f1495278f56c60d43f31453fefea6875b4928'
  }
  s.ios.deployment_target = '15.6'
  s.vendored_frameworks = 'GLTFKit2.xcframework'
end
