//
//  BBSInspectorInformation.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

let BBSInspectorInformationDefaultCaptionColor = UIColor.blackColor()

@objc public class BBSInspectorInformation: NSObject
{
    public var title: String
    public var caption: String
    public var captionColor: UIColor
    public var action: (() -> Void)?
    
    // MARK: - Initializers
    
    /**
    Convenience initializer, default black color will be applied
    
    :param: title A String to display as the title
    :param: caption A String to display as the caption
    */
    convenience public init(title: String, caption: String)
    {
        self.init(title: title, caption: caption, captionColor: BBSInspectorInformationDefaultCaptionColor, action: nil)
    }
    
    /**
    Default initializer, create an InspectorInformation with given parameters
    
    :param: title A String to display as the title
    :param: caption A String to display as the caption
    :param: captionColor The UIColor to draw the caption in
    :param: action An optional block to be executed when selected, paste to pasteboard action is the default behaviour otherwise
    */
    public init(title: String, caption: String, captionColor: UIColor, action: (() -> Void)?)
    {
        self.title = title
        self.caption = caption
        self.captionColor = captionColor
        self.action = action
    }
    
    // MARK: - Actions
    
    /**
    Execute associated action
    */
    internal func executeAction()
    {
        if let action = action {
            action()
        } else {
            pasteToPasteboard()
        }
    }
    
    /**
    Paste caption content into pasteboard
    */
    internal func pasteToPasteboard()
    {
        UIPasteboard.generalPasteboard().string = caption
        
        UIAlertView(title: NSLocalizedString("Information", comment: ""),
            message: NSString(format: NSLocalizedString("<%@> copied to pasteboard", comment: ""), caption) as String,
            delegate: nil,
            cancelButtonTitle: NSLocalizedString("OK", comment: "")
            ).show()
    }
    
    // MARK: - Getters
    
    internal var attributedCaption: NSAttributedString {
        return NSAttributedString(string: caption, attributes: [
            NSForegroundColorAttributeName : captionColor
            ])
    }
}