Pod::Spec.new do |s|
s.name         = 'TestPodCC'
    s.version      = '1.0.2'
    s.summary      = 'a component of photo browser on iOS'
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

end