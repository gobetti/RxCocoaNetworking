Pod::Spec.new do |s|
 s.name = 'RxCocoaNetworking'
 s.version = '0.2.0'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A Moya-inspired, RxTest-testable networking framework built on top of RxCocoa'
 s.homepage = 'https://github.com/gobetti/RxCocoaNetworking'
 s.social_media_url = 'https://twitter.com/mwgobetti'
 s.authors = { "Marcelo Gobetti" => "mwgobetti@gmail.com" }
 s.source = { :git => "https://github.com/gobetti/RxCocoaNetworking.git", :tag => "v"+s.version.to_s }
 s.platforms = { :ios => "9.0", :osx => "10.11", :tvos => "10.0", :watchos => "3.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift"
     ss.framework  = "Foundation"

 s.dependency 'RxCocoa', '~> 4.3'
 end

end
