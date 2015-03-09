//
//  InspectorCornerButton.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

let InspectorCornerButtonEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)

internal class InspectorCornerButton: UIButton
{
    /**
    Current button style
    */
    private var style: InspectorCornerButtonStyle = InspectorCornerButtonStyle.Plus
    
    /**
    Line layers
    */
    private var line1Layer: CAShapeLayer = CAShapeLayer()
    private var line2Layer: CAShapeLayer = CAShapeLayer()
    
    /**
    Dimension
    */
    private var dimension: CGFloat {
        let width = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.left - self.contentEdgeInsets.right
        let height = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom
        return min(width, height)
    }
    
    /**
    Center point of view
    */
    private var pivot: CGPoint {
        return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    }
    
    // MARK: - Initializers
    
    override internal init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required internal init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup()
    {
        self.backgroundColor = UIColor.blackColor()
        self.clipsToBounds = true
        self.contentEdgeInsets = InspectorCornerButtonEdgeInsets
        
        // Corner mask
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: self.bounds,
            byRoundingCorners: UIRectCorner.TopLeft,
            cornerRadii: CGSizeMake(5.0, 0.0)).CGPath
        self.layer.mask = mask
        
        // Prepare lines layers
        for layer in [ line1Layer, line2Layer] {
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = UIColor.whiteColor().CGColor
            layer.anchorPoint = CGPointZero
            layer.lineWidth = 2.0
            layer.lineJoin = kCALineJoinRound
            layer.lineCap = kCALineCapRound
            layer.contentsScale = self.layer.contentsScale
            layer.path = CGPathCreateMutable()
            self.layer.addSublayer(layer)
        }
    }
    
    // MARK: - Setters
    
    /**
    Update button style with or without animation
    
    :param: style A registered InspectorCornerButtonStyle
    :param: animated Wether or not the change should be animated
    */
    internal func setStyle(style newStyle: InspectorCornerButtonStyle, animated: Bool)
    {
        self.style = newStyle
        
        // Prepare paths
        var line1path: CGPathRef
        var line2path: CGPathRef
        switch style
        {
        case InspectorCornerButtonStyle.Plus:
            line1path = self.createCenteredLineWithRadius(dimension / 2.0, angle: CGFloat(M_PI_2), offset: CGPointZero)
            line2path = self.createCenteredLineWithRadius(dimension / 2.0, angle: 0, offset: CGPointZero)
            
        case InspectorCornerButtonStyle.Close:
            line1path = self.createCenteredLineWithRadius(dimension / 2.0, angle: -CGFloat(M_PI_4), offset: CGPointZero)
            line2path = self.createCenteredLineWithRadius(dimension / 2.0, angle: CGFloat(M_PI_4), offset: CGPointZero)
            
        default:
            return
        }
        
        // Animate if needed
        if animated {
            let duration = 0.3
            
            // Line 1
            let line1Animation = CABasicAnimation(keyPath: "path")
            line1Animation.removedOnCompletion = false
            line1Animation.duration = duration
            line1Animation.fromValue = line1Layer.path
            line1Animation.toValue = line1path
            line1Animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            line1Layer.addAnimation(line1Animation, forKey: "animateLine1Path")
            
            // Line 2
            let line2Animation = CABasicAnimation(keyPath: "path")
            line2Animation.removedOnCompletion = false
            line2Animation.duration = duration
            line2Animation.fromValue = line2Layer.path
            line2Animation.toValue = line2path
            line2Animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            line2Layer.addAnimation(line2Animation, forKey: "animateLine2Path")
        }
        
        line1Layer.path = line1path
        line2Layer.path = line2path
    }
    
    // MARK: - Path factory
    
    private func createCenteredLineWithRadius(radius: CGFloat, angle: CGFloat, offset: CGPoint) -> CGPathRef
    {
        let c = CGFloat(cosf(Float(angle)))
        let s = CGFloat(sinf(Float(angle)))
        
        let path = CGPathCreateMutable()
        let pivot = self.pivot
        CGPathMoveToPoint(path, nil, pivot.x + offset.x + radius * c, pivot.y + offset.y + radius * s)
        CGPathAddLineToPoint(path, nil, pivot.x + offset.x - radius * c, pivot.y + offset.y - radius * s)
        
        return path
    }
}

enum InspectorCornerButtonStyle
{
    case Plus, Close
}