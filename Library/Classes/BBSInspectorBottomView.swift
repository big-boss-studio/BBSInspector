//
//  BBSInspectorBottomView.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

let BBSInspectorBottomViewGapX = CGFloat(10.0)
let BBSInspectorBottomViewCornerSide = CGFloat(30.0)
let BBSInspectorBottomViewRatioPixelDifference = CGFloat(1.0)

internal class BBSInspectorBottomView: UIView
{
    /**
    Delegate
    */
    internal var delegate: BBSInspectorBottomViewDelegate?
    
    /**
    Internal views
    */
    private var contentLabel: UILabel!
    private var stripView: UIView!
    private var cornerButton: BBSInspectorCornerButton!
    
    /**
    Content displayed in bottom view label
    */
    private var content: String? {
        if let infoDictionary = NSBundle.mainBundle().infoDictionary {
            let appName = infoDictionary[kCFBundleNameKey as String] as! String
            let appVersion = infoDictionary["CFBundleShortVersionString"] as! String
            let appBuild = infoDictionary[kCFBundleVersionKey as String] as! String
            return "\(appName) (\(appVersion) | \(appBuild))"
        }
        return nil
    }
    
    /**
    Current state of opening
    */
    var opened: Bool = false
    
    // MARK: - Initializers
    
    override internal init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required internal init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleTopMargin]
    }
    
    // MARK: - Setup
    
    private func setup()
    {
        reset()
        
        let stripViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - BBSInspectorBottomViewCornerSide / 2 + BBSInspectorBottomViewRatioPixelDifference,
            CGRectGetHeight(self.bounds))
        
        // Content label
        let delegateContent = delegate?.contentToDisplayInInspectorBottomView(self)
        let content = delegateContent == nil ? self.content : delegateContent
        let contentLabel = UILabel(frame: CGRectMake(BBSInspectorBottomViewGapX,
            0,
            CGRectGetWidth(stripViewFrame) - 2 * BBSInspectorBottomViewGapX,
            CGRectGetHeight(stripViewFrame)))
        contentLabel.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        contentLabel.font = UIFont.systemFontOfSize(12.0)
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.text = content
        
        // Use blur for strip view on iOS 8+ systems, a simple semi-transparent view otherwise
        var stripView: UIView
        if #available(iOS 8.0, *)
        {
            stripView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
            stripView.frame = stripViewFrame
            (stripView as! UIVisualEffectView).contentView .addSubview(contentLabel)
        }
        else
        {
            stripView = UIView(frame: stripViewFrame)
            
            let transparentView = UIView(frame: stripView.bounds)
            transparentView.backgroundColor = UIColor.blackColor()
            transparentView.alpha = 0.5
            transparentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            
            stripView.addSubview(transparentView)
            stripView.addSubview(contentLabel)
        }
        stripView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        stripView.hidden = true
        self.addSubview(stripView)
        
        // Corner button
        let cornerButton = BBSInspectorCornerButton(frame: CGRectMake(CGRectGetWidth(self.bounds) - BBSInspectorBottomViewCornerSide, 0, BBSInspectorBottomViewCornerSide, CGRectGetHeight(self.bounds)))
        cornerButton.setStyle(style: BBSInspectorCornerButtonStyle.Plus, animated: false)
        cornerButton.addTarget(self, action: "toggle", forControlEvents: UIControlEvents.TouchUpInside)
        cornerButton.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleTopMargin]
        self.addSubview(cornerButton)
        
        // Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapDetected:")
        stripView.addGestureRecognizer(tapGestureRecognizer)
        
        // Hold important views
        self.contentLabel = contentLabel
        self.stripView = stripView
        self.cornerButton = cornerButton
    }
    
    private func reset()
    {
        contentLabel = nil
        stripView = nil
        cornerButton = nil
    }
    
    // MARK: - State management
    
    /**
    Add inspector bottom view to screen
    */
    internal func show(inView view: UIView)
    {
        self.frame = CGRectMake(0, CGRectGetHeight(view.frame) - BBSInspectorBottomViewCornerSide + BBSInspectorBottomViewRatioPixelDifference, CGRectGetWidth(view.frame), BBSInspectorBottomViewCornerSide)
        setup()
        view.addSubview(self)
    }
    
    /**
    Remove inspector bottom view from screen
    */
    internal func hide()
    {
        self.removeFromSuperview()
    }
    
    /**
    Open or close inspector bottom view according to its current state
    */
    internal func toggle()
    {
        if self.superview == nil {
            return
        }
        
        // Animation variables
        let initialY = (opened ? 0 : CGRectGetHeight(self.bounds) + BBSInspectorBottomViewRatioPixelDifference)
        let finalY = (opened ? CGRectGetHeight(self.bounds) + BBSInspectorBottomViewRatioPixelDifference : 0)
        
        // Prepare animation
        stripView.frame.origin.y = initialY
        stripView.hidden = false
        
        // Animate
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.stripView.frame.origin.y = finalY
            }) { (finished) -> Void in
                self.opened = !self.opened
                if !self.opened {
                    self.stripView.hidden = true
                }
        }
        
        // Update corner button style
        cornerButton.setStyle(style: (opened ? BBSInspectorCornerButtonStyle.Plus : BBSInspectorCornerButtonStyle.Close), animated: true)
    }
    
    // MARK: - UI Actions
    
    internal func tapDetected(gesture: UITapGestureRecognizer)
    {
        delegate?.inspectorBottomViewTapped(self)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        if opened {
            return super.hitTest(point, withEvent: event)
        } else {
            return CGRectContainsPoint(cornerButton.frame, self.convertPoint(point, toView: self)) ? self.cornerButton : nil
        }
    }
}

protocol BBSInspectorBottomViewDelegate
{
    /**
    Called when user tap on an open inspector bottom view
    
    - parameter inspectorBottomView: The touched inspector bottom view
    */
    func inspectorBottomViewTapped(bottomView: BBSInspectorBottomView)
    
    /**
    Called when configuring the bottom view, default content will be used if return string is empty
    
    - parameter bottomView: The calling InspectorBottomView object
    - returns: a string to be displayed in bottom view label
    */
    func contentToDisplayInInspectorBottomView(bottomView: BBSInspectorBottomView) -> String?
}
