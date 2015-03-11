//
//  AppDelegate.swift
//  BBSInspectorDemo
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        /**
        1) Because we want to add items to default information items list, we create a custom data source
        */
        let customInspectorDataSource: BBSInspectorDataSource = BBSInspectorDataSource()
        
        /**
        2) We add some items as custom inspector information items
        */
        customInspectorDataSource.customInspectorInformationItems = {
            return [
                BBSInspectorInformation(title: "Test information", caption: "Click here to display an alert", captionColor: UIColor.blueColor(), action: { () -> Void in
                    UIAlertView(title: "Information", message: "Hello, World!", delegate: nil, cancelButtonTitle: "OK").show()
                })
            ]
        }
        BBSInspector.sharedInstance.dataSource = customInspectorDataSource
        
        /**
        3) We also can override default bottom view content, the default value otherwise is ```Bundle name (bundle version)```
        */
        // customInspectorDataSource.excerptContent = "\(NSBundle.mainBundle().infoDictionary![kCFBundleNameKey] as String) - v\(NSBundle.mainBundle().infoDictionary![kCFBundleVersionKey] as String) - PRODUCTION"
        
        /**
        4) The make key and visible must be called before enabling inspector since it use a lot the application keyWindow
        */
        window?.makeKeyAndVisible()
        
        /**
        5) Finally, enable inspector
        */
        BBSInspector.sharedInstance.enableInspector()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        /**
        6) Data source device token should be set when received
        */
        BBSInspector.sharedInstance.dataSource.deviceToken = deviceToken
        
        /**
        7) Every time an item is added, removed or updated at runtime, reload data
        */
        BBSInspector.sharedInstance.reloadInspectorInformation()
    }
}

