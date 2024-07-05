Pod::Spec.new do |spec|

  spec.name         = "SafetyKuvrrKit"
  spec.version      = "1.0.10"
  spec.summary      = "SafetyKuvrr app functionalities integration separately."
  spec.description  = "It is a separate integration for SafetyKuvrr app functionalities."
  spec.homepage     = "https://github.com/Sm038229/KuvrrKit"
  spec.license      = "MIT"
  spec.author       = { "Sachin Mishra" => "sachinmishrahp@gmail.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/Sm038229/SafetyKuvrrKit.git", :tag => spec.version.to_s }
  spec.source_files  = "SafetyKuvrrKit/**/*.{Swift}"
  spec.swift_versions = "5.0"
  spec.dependency 'Alamofire' # , '~> 0.1.0'
  spec.dependency 'INTULocationManager'
  spec.dependency 'DeviceGuru'
  spec.dependency 'PermissionKit'
  
  spec.framework = "UIKit", "Foundation", "CoreLocation" #, "CoreBluetooth", "ExternalAccessory"
  # spec.source_files = "SafetyKuvrrKit/**/*.{swift,c,h,m}"
  # spec.resources = "SafetyKuvrrKit/**/*.{png,jpeg,jpg,storyboard,xib,json}"

end
