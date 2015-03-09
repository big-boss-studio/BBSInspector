#
# Be sure to run `pod lib lint BBSInspector.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BBSInspector"
  s.version          = "0.1.0"
  s.summary          = "Extendable device and application information in your iOS application"
  s.homepage         = "https://github.com/bigbossstudio-dev/BBSInspector"
  s.screenshots      = "https://raw.github.com/bigbossstudio-dev/BBSInspector/master/Screenshots/01_closed.png", "https://raw.github.com/bigbossstudio-dev/BBSInspector/master/Screenshots/02_opened.png", "https://raw.github.com/bigbossstudio-dev/BBSInspector/master/Screenshots/03_inspector.png"
  s.license          = 'MIT'
  s.author           = { "Cyril Chandelier" => "cyril.chandelier@gmail.com" }
  s.source           = { :git => "https://github.com/bigbossstudio-dev/BBSInspector.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
