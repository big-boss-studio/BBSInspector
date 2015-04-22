//
//  BBSInspectorDataSource.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 06/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

@objc public class BBSInspectorDataSource
{
    /**
    Served data array
    */
    private var informationItems: [BBSInspectorInformation]
    
    /**
    Entry point to register more information items in list
    */
    public var customInspectorInformationItems: (() -> [BBSInspectorInformation])?
    
    /**
    Convenient accessor for the count of information items
    */
    public var count: Int {
        return informationItems.count
    }
    
    /**
    Read only access to information items through subscript syntax
    */
    public subscript(index: Int) -> BBSInspectorInformation {
        get {
            return informationItems[index]
        }
    }
    
    /**
    Text displayed in bottom view, default is: ```Bundle name (Bundle version)```
    */
    public var excerptContent: String?
    
    /**
    Device push notifications token
    */
    public var deviceToken: NSData?
    
    // MARK: - Initializers
    
    public init()
    {
        informationItems = [BBSInspectorInformation]()
    }
    
    // MARK: - Data management
    
    /**
    Recompute all information items and execute custom information items closure to fill an
    array of InspectorInformation
    */
    internal func reloadData()
    {
        informationItems.removeAll(keepCapacity: false)
        
        // App information name
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Bundle name", comment: ""), caption: infoDictionary[kCFBundleNameKey] as! String))
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Bundle identifier", comment: ""), caption: infoDictionary[kCFBundleIdentifierKey] as! String))
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Version", comment: ""), caption: infoDictionary["CFBundleShortVersionString"] as! String))
        
        // Device information
        let device = UIDevice.currentDevice()
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Device model", comment: ""), caption: device.model))
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Device name", comment: ""), caption: device.name))
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("System name", comment: ""), caption: device.systemName))
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("System version", comment: ""), caption: device.systemVersion))
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Identifier for vendor", comment: ""), caption: device.identifierForVendor.UUIDString))
        
        // Locale
        let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        let language = NSLocale.preferredLanguages().first as! String
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Locale", comment: ""), caption: "\(language)_\(countryCode)"))
        
        // Push notifications
        var pushNotificationsEnabled = false
        if UIApplication.sharedApplication().respondsToSelector(Selector("registerUserNotificationSettings:")) {
            let currentUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
            pushNotificationsEnabled = (currentUserNotificationSettings.types != UIUserNotificationType.None)
        } else {
            let enabledRemoteNotificationTypes = UIApplication.sharedApplication().enabledRemoteNotificationTypes()
            pushNotificationsEnabled = (enabledRemoteNotificationTypes != UIRemoteNotificationType.None)
        }
        informationItems.append(BBSInspectorInformation(title: NSLocalizedString("Push notifications", comment: ""), caption: (pushNotificationsEnabled ? NSLocalizedString("Enabled", comment: "") : NSLocalizedString("Disabled", comment: "")), captionColor: (pushNotificationsEnabled ? UIColor.greenColor() : UIColor.redColor()), action: nil))
        
        // Device token
        if (pushNotificationsEnabled) {
            var deviceTokenString: String = NSLocalizedString("Undefined", comment: "")
            if deviceToken != nil {
                deviceTokenString = deviceToken!.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
            }
            informationItems.append(BBSInspectorInformation(title: "Push token", caption: deviceTokenString))
        }
        
        // Custom items
        if let customInspectorInformationItems = self.customInspectorInformationItems {
            for information in customInspectorInformationItems() {
                informationItems.append(information)
            }
        }
    }
}