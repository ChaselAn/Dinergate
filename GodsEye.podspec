Pod::Spec.new do |s|
    s.name         = 'GodsEye'
    s.version      = '0.0.1-pre'
    s.summary      = 'APM'
    s.homepage     = 'https://github.com/ChaselAn/GodsEye'
    s.license      = 'MIT'
    s.authors      = {'ChaselAn' => '865770853@qq.com'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'git@github.com:ChaselAn/GodsEye.git', :tag => s.version}
    s.source_files = 'APMDemo/GodsEye/*.swift'
    s.requires_arc = true
    # s.resources    = 'APMDemo/*.xcassets'
    s.swift_version = '5.0'
end
