Pod::Spec.new do |s|
    s.name         = 'Dinergate'
    s.version      = '0.1.1'
    s.summary      = 'APM'
    s.homepage     = 'https://github.com/ChaselAn/Dinergate'
    s.license      = 'MIT'
    s.authors      = {'ChaselAn' => '865770853@qq.com'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://github.com/ChaselAn/Dinergate.git', :tag => s.version}
    s.source_files = 'APMDemo/Dinergate/*.swift'
    s.requires_arc = true
    s.swift_version = '5.2'
    s.dependency 'DinergateBrain', '0.1.0'
    s.dependency 'SQLite.swift', '~> 0.12'
end
