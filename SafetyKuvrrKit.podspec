Pod::Spec.new do |spec|

  spec.name           = "SafetyKuvrrKit"
  spec.version        = "1.0.19"
  spec.summary        = "SafetyKuvrr app functionalities integration separately."
  spec.description    = "It is a separate integration for SafetyKuvrr app functionalities."
  spec.homepage       = "https://github.com/Sm038229/SafetyKuvrrKit"
  spec.license        = "MIT"
  spec.author         = { "Sachin Mishra" => "sachinmishrahp@gmail.com" }
  spec.platform       = :ios, "13.0"
  spec.source         = { :git => "https://github.com/Sm038229/SafetyKuvrrKit.git", :tag => spec.version.to_s }
  spec.readme         = "README.md"
  spec.source_files   = ["SafetyKuvrrKit/**/*.{swift}"]
  spec.resources      = ["SafetyKuvrrKit/**/*.{xib,storyboard,xcassets,imageset,png,jpg,jpeg}"]
  spec.resource_bundles = {
     'SafetyKuvrrKit' => ['SafetyKuvrrKit/**/*.{xib,storyboard,xcassets,imageset,png,jpg,jpeg}'] 
  }
  spec.swift_versions = "5.0"
  spec.dependency 'Alamofire' # , '~> 0.1.0'
  spec.dependency 'INTULocationManager'
  spec.dependency 'DeviceGuru'
  spec.dependency 'PermissionKit'
  spec.dependency 'AgoraRtcEngine_iOS'
  spec.dependency 'KeychainSwift'
  spec.dependency 'SDWebImage'
  spec.dependency 'ActiveLabel'
  
  spec.framework = "UIKit", "Foundation", "CoreLocation" #, "CoreBluetooth", "ExternalAccessory"

end
