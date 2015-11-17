#
#  Be sure to run `pod spec lint BBSInspector.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "BBSInspector"
  s.version      = "0.1.5"
  s.summary      = "Extendable device and application information in your iOS application"
  s.homepage     = "https://github.com/bigbossstudio-dev/BBSInspector"
  # s.screenshots = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT" }
  s.author       = { "Cyril Chandelier" => "cyril.chandelier@gmail.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/bigbossstudio-dev/BBSInspector.git", :tag => "0.1.5" }
  s.source_files = "Classes", "Library/Classes/*.{h,m,swift}"
  s.requires_arc = true
end
