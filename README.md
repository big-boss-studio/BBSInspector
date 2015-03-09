# BBSInspector

/!\ Work in progress, this library is not working at the moment. /!\

Extendable device and application information in your iOS application

## Installation

This library has not been shipped to Cocoapods, coming soon.

## Getting started

Simply enable inspector in your ```AppDelegate``` (```application:didFinishLaunchingWithOptions:``` is a good place to do it) to add right bottom button to your app:
```swift
[...]
window?.makeKeyAndVisible()
[...]
self.enableInspector()
[...]
```
Mind that the ```makeKeyAndVisible``` of the window should have been called BEFORE enabling inspector, if using a storyboard, this line doesn't come with the template, simply add it before calling the ```enableInspector``` method.

## Extending BBSInspector

You can add custom information to BBSInspector by providing an ```InspectorDataSource``` to the method :

```swift
let customInspectorDataSource: InspectorDataSource = InspectorDataSource()
customInspectorDataSource.customInspectorInformationItems = {
    return [
        // Custom InspectorInformation items
    ]
}
self.enableInspector(dataSource: customInspectorDataSource)
```

A basic information item represents data with a title and a description, touching its cell in Inspector will copy the caption into clipboard.

```swift
InspectorInformation(title: "Environment", caption: "PRODUCTION")
```

An action information item can be registered to have an action executed when user clicks onto the its cell :

```swift
InspectorInformation(title: "Test information", caption: "Click here to display an alert", captionColor: UIColor.blueColor(), action: { () -> Void in
            UIAlertView(title: "Information", message: "Hello, World!", delegate: nil, cancelButtonTitle: "OK").show()
        })
```