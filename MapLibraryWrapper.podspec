
# Be sure to run `pod lib lint MapLibraryWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MapLibraryWrapper"
  s.version          = "0.0.1"
  s.summary          = "Wrapper Swift library of Map libraries(e.g. MapKit, Google Maps)."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Wrapper Swift library of Map libraries.
To easy the change of the Map Library from later by using this library.

it supports following libraries.
- MapKit
- Google Maps.
                       DESC

  s.homepage         = "https://github.com/nakaji-dayo/MapLibraryWrapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "nakaji-dayo" => "nakaji.dayo@gmail.com" }
  s.source           = { :git => "https://github.com/nakaji-dayo/MapLibraryWrapper.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nakaji_dayo'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MapLibraryWrapper' => ['Pod/Assets/*.png']
  }
  s.ios.resource_bundle = { 'MapLibraryWrapper-ios' => 'Resources/*.png' }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = "Accelerate", "AVFoundation", "CoreData", "CoreLocation", "CoreText", "Foundation", "GLKit", "ImageIO", "OpenGLES", "QuartzCore", "SystemConfiguration", "GoogleMaps"
  # s.dependency 'GoogleMaps'
  s.libraries = "c++", "icucore", "z"
  s.vendored_frameworks = 'Dependencies/GoogleMaps.framework'

  def s.pre_install (pod, target_definition)
    Dir.chdir(pod.root) do
      `./download-googlemaps.sh`
    end
  end
end
