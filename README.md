# BBSInspector

[![Version](https://img.shields.io/cocoapods/v/BBSInspector.svg?style=flat)](http://cocoadocs.org/docsets/BBSInspector)
[![License](https://img.shields.io/cocoapods/l/BBSInspector.svg?style=flat)](http://cocoadocs.org/docsets/BBSInspector)
[![Platform](https://img.shields.io/cocoapods/p/BBSInspector.svg?style=flat)](http://cocoadocs.org/docsets/BBSInspector)

Extendable device and application information in your iOS application

![ScreenShot](https://raw.github.com/bigbossstudio-dev/BBSInspector/master/Screenshots/01_opened.png)
![ScreenShot](https://raw.github.com/bigbossstudio-dev/BBSInspector/master/Screenshots/03_inspector.png)

## Installation

Using CocoaPods (iOS 8 and above): ```pod 'BBSInspector'```

BBSInspector can also be used with older iOS 7 but CocoaPods doesn't support Swift pods for them. You can still copy the content of ```Library/Classes/``` into your project or use a Git submodule (prefered).

## Getting started

Simply enable inspector (for instance, ```AppDelegate```'s ```application:didFinishLaunchingWithOptions:``` is a good place to do it) to add right bottom button to your app:
```swift
[...]
window?.makeKeyAndVisible()
[...]
BBSInspector.sharedInstance.enableInspector()
[...]
```
Mind that the ```makeKeyAndVisible``` of the window should have been called BEFORE enabling inspector (a crash will occur otherwise), if using a storyboard, this line doesn't come with the template, simply add it before calling the ```enableInspector``` method.

## Extending BBSInspector

You can add custom information to BBSInspector by providing a ```BBSInspectorDataSource``` to the method :

```swift
let customInspectorDataSource: BBSInspectorDataSource = BBSInspectorDataSource()
customInspectorDataSource.customInspectorInformationItems = {
    return [
    	// Custom BBSInspectorInformation items
    ]
}
BBSInspector.sharedInstance.dataSource = customInspectorDataSource
```

A basic information item represents data with a title and a description, touching its cell in Inspector will copy the caption into clipboard.

```swift
BBSInspectorInformation(title: "Environment", caption: "PRODUCTION")
```

An action information item can be registered to have an action executed when user clicks onto the its cell :

```swift
BBSInspectorInformation(title: "Test information", caption: "Click here to display an alert", captionColor: UIColor.blueColor(), action: { () -> Void in
            UIAlertView(title: "Information", message: "Hello, World!", delegate: nil, cancelButtonTitle: "OK").show()
        })
```

## Reloading data

Once computed, data can be displayed in the inspector modal. But sometimes, data isn't static and should be reloaded (for instance when a registration token has arrived or when user logged in).

```swift
BBSInspector.sharedInstance.reloadInspectorInformation()
```

## Push token

If your application supports push notifications, you can set this data to ```BBSInspectorDataSource``` object.

```swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
{
	BBSInspector.sharedInstance.dataSource.deviceToken = deviceToken
	BBSInspector.sharedInstance.reloadInspectorInformation()
}
```

## Objective-C

This component is Objective-C compatible. 
