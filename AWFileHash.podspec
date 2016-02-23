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
s.version          = "0.2.0"
s.summary          = "An Objective-C implementation of the MD5, SHA1, SHA512 hash algorithms and CRC32b checksum."
s.description      = <<-DESC
An Objective-C implementation of the MD5, SHA1, SHA512 hash algorithms and CRC32b checksum. Performs it chunked and consumes almost no memory while running, making it suitable to both OSX and iOS.
DESC
s.homepage         = "https://github.com/leetal/AWFileHash"
s.license          = 'MIT'
s.author           = { "Alexander Widerberg" => "widerbergaren@gmail.com" }
s.source           = { :git => "https://github.com/leetal/AWFileHash.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/widerbergaren'
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
    'AWFileHash' => ['Pod/Assets/*.png']
}
s.frameworks = 'Security', 'CoreFoundation', 'Photos', 'Foundation', 'AssetsLibrary'
end
