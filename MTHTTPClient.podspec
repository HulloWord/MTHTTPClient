 
Pod::Spec.new do |s|
  s.name             = 'MTHTTPClient'
  s.version          = '0.1.1'
  s.summary          = '基于AFN和RAC的网络请求工具'
  s.description      = '面对对象设计，基于AFN和RAC的网络请求工具，暂未加入缓存功能'
  s.homepage         = 'https://github.com/lyleLH/MTHTTPClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom Liu' => ' v2top1lyle@gmail.com' }
  s.source           = { :git => 'git@github.com:lyleLH/MTHTTPClient.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'MTHTTPClient/Classes/**/*'
  s.dependency 'MJRefresh'
  s.dependency 'AFNetworking'
  s.dependency 'ReactiveObjC', '~> 3.1.1'
  s.dependency 'MTCategoryComponent'

end
