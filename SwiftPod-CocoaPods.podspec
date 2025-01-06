Pod::Spec.new do |s|
    s.name         = 'SwiftPod-CocoaPods'
    s.version      = '1.0.7'
    s.summary      = 'A Dependency Injection library for Swift'
    s.description  = 'SwiftPod is a lightweight and easy-to-use Dependency Injection (DI) library for Swift. It is designed to be straightforward, efficient, and most importantly safe!'
    s.homepage     = 'https://github.com/robert-northmind/SwiftPod'
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.author       = { 'Robert Magnusson' => 'robert@northmind.io' }
    s.platforms    = { :ios => '11.0', :osx => '10.13', :tvos => '11.0', :watchos => '4.0' }
    s.source       = { :git => 'https://github.com/robert-northmind/SwiftPod.git', :tag => s.version.to_s }
    s.source_files = 'Sources/SwiftPod/**/*.{swift}'
    s.swift_version = '5.8'
end