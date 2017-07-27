Pod::Spec.new do |s|
s.name         = 'STNetwork'
    s.version      = ‘1.0.3’
    s.summary      = 'network on iOS'
    s.homepage     = 'https://github.com/haivy/STNetwork'
    s.description  = <<-DESC
  									It is a component for Network.
                   DESC
    s.license      = 'MIT'
    s.authors      = {'qiang' => '623057062@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/haivy/STNetwork.git', :tag => s.version}

    s.source_files = 'STNetwork/**/*.{h,m}'
    s.requires_arc = true
  	s.ios.deployment_target = "7.0"
	s.framework = "CFNetwork"
	s.dependency "AFNetworking", "~> 3.0"

end