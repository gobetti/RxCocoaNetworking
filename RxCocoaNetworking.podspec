Pod::Spec.new do |s|
 s.name = 'RxCocoaNetworking'
 s.version = '0.0.1'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A Moya-inspired, RxTest-testable networking framework built on top of RxCocoa'
 s.homepage = 'https://github.com/gobetti/RxCocoaNetworking'
 s.social_media_url = 'https://twitter.com/mwgobetti'
 s.authors = { "Marcelo Gobetti" => "mwgobetti@gmail.com" }
 s.source = { :git => "https://github.com/gobetti/RxCocoaNetworking.git", :tag => "v"+s.version.to_s }
 s.platforms = { :ios => "8.0", :osx => "10.10", :tvos => "9.0", :watchos => "2.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift"
     ss.framework  = "Foundation"
 end

end
