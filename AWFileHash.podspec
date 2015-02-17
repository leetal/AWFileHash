#
# Be sure to run `pod lib lint AWFileHash.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "AWFileHash"
s.version          = "1.0.0"
s.summary          = "An Objective-C implementation of the MD5, SHA1, SHA512 hash algorithms."
s.description      = <<-DESC
An Objective-C implementation of the MD5, SHA1, SHA512 hash algorithms. Performs it chunked and consumes almost no memory while running, making it suitable to both OSX and iOS.
DESC
s.homepage         = "https://github.com/leetal/AWFileHash"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "Alexander Widerberg" => "alexander.widerberg@cloudme.com" }
s.source           = { :git => "https://github.com/leetal/AWFileHash.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/widerbergaren'

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
'AWFileHash' => ['Pod/Assets/*.png']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'Security', 'CoreFoundation', 'Photos', 'Foundation', 'AssetsLibrary'
# s.dependency 'AFNetworking', '~> 2.3'
end
