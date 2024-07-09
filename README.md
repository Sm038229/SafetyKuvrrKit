> [Readme](README.md)
# Getting Started with iOS SafetyKuvrrKit

## Introduction

Built for SoS, 911 and WalkSafe events for `Safety Kuvrr` App.

## Run through the demo

`SafetyKuvrrKit` is integrated in the SafetyKuvrrExample demo. You can download the iOS demo from our [open-source repository](https://github.com/Sm038229/KuvrrKit) on Github.

### Install the required SDKs and `SafetyKuvrrKit`

The source code of the demo does not involve SDKs and `SafetyKuvrrKit`. You can directly import them or install them using CocoaPods.

Install CocoaPods if you have not. For details, see [Getting Started with CocoaPods](https://guides.cocoapods.org/using/getting-started.html).

If you use CocoaPods for installation, first navigate to the directory where `podfile` resides and run the following command in the Terminal:

```
pod install
```

### Run the demo

After the required SDKs and `SafetyKuvrrKit` are installed, open the workspace `SafetyKuvrrExample.xcworkspace` on Xcode and connect to the mobile phone to run the demo.

## Prerequisites

Before proceeding, ensure that your development environment meets the following requirements:

- A device running iOS 13.0 or above.
- SafetyKuvrrKit is integrated to provide basic functions like login, SoS, 911, and WalkSafe.
- An [SafetKuvrr app](https://www.kuvrr.com) is created.

## Integrate `SafetyKuvrrKit`

Follow these steps to integrate `SafetyKuvrrKit`:

1. The user calls the API to initialize `SafetyKuvrrKit`.
2. The caller calls the API to get device details.
3. The caller calls the API to initiate 911.

### Import `SafetyKuvrrKit`

`SafetyKuvrrKit` depends on the `Alamofire`, `INTULocationManager`, `DeviceGuru`, and `PermissionKit` libraries. Therefore, you also need to import these libraries to the project, for example by using CocoaPods.

As `SafetyKuvrrKit` is a dynamic library, you must add use_frameworks! to `podfile`.

`SafetyKuvrrKit` can be imported manually or using CocoaPods.

#### Import `SafetyKuvrrKit` by using CocoaPods

In the Terminal, navigate to the root directory of the project and run the `pod init` command to generate the `Podfile` file in the project folder.

Open the `Podfile` file and modify the file content as follows. Remember to replace `AppName` with your own app name.

```
use_frameworks!
target 'AppName' do
    pod 'SafetyKuvrrKit'
end
```

In the Terminal, run the `pod update` command to update the version of the local `SafetyKuvrrKit`.

Run the `pod install` command to install `SafetyKuvrrKit`. If the installation succeeds, the message `Pod installation complete!` is displayed in the Terminal. Then the `xcworkspace` file is generated in the project folder.

#### Import `SafetyKuvrrKit` manually

1. Copy `SafetyKuvrrKit.framework` downloaded when you run through the demo, to the project folder.
2. On Xcode, choose **Project Settings > General**, drag `SafetyKuvrrKit.framework` to the project, and set `SafetyKuvrrKit.framework` to `Embed & Sign` under `Frameworks, Libraries, and Embedded Content`.

### Add permissions

The app requires permissions of location. In the `info.plist` file, click `+` to add the following information:

| Key                                    | Type   | Value                                                        |
| -------------------------------------- | ------ | ------------------------------------------------------------ |
| Privacy - Location Always and When in use usage description | String | The description, like "SafetyKuvrrKit needs to use your location." |

If you hope to run `SafetyKuvrrKit` in the background, you also need to add the permission to get location in the background:

1. Click `+` to add `Required background modes` to `info.plist`, with `Type` set as `Array`.
2. Add the `Location Updates` element under `Array`.

### Usage
If you install from *CocoaPods*, you have to import the module. If you used drag and drop then there is no need of import
``` swift
import SafetyKuvrrKit
```
For login:
``` swift
SafetyKuvrr.login(withEmail: "email@example.com") { response in

}, failure: {

})
```
For 911:
``` swift
SafetyKuvrr.raiseEvent(isEMS: true, emsNumber: 911, success: {

}, failure: {

})
```
For SoS:
``` swift
SafetyKuvrr.raiseEvent(isSoS: true, success: {

}, failure: {

})
```
Checkout [`Example Project`](Example/)!
