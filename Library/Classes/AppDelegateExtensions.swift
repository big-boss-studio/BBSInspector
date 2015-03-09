//
//  AppDelegateExtension.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate: InspectorBottomViewDelegate, InspectorViewControllerDataSource, InspectorViewControllerDelegate
{
    // MARK: - State managament
    
    private func setup()
    {
        inspectorBottomView = InspectorBottomView()
        inspectorBottomView?.delegate = self
        
        inspectorDataSource?.reloadData()
    }
    
    private func cleanup()
    {
        inspectorDataSource = nil
        inspectorBottomView = nil
        inspectorViewController = nil
        inspectorNavigationController = nil
    }
    
    /**
    Add a inspector component to the bottom of screen to enable Inspector features
    */
    func enableInspector(dataSource: InspectorDataSource = InspectorDataSource())
    {
        inspectorDataSource = dataSource
        setup()
        inspectorBottomView?.show(inView: UIApplication.sharedApplication().keyWindow!)
    }
    
    /**
    Remove inspector component from screen
    */
    func disableInspector()
    {
        inspectorBottomView?.hide()
        cleanup()
    }
    
    /**
    Reload inspector content
    */
    func reloadInspectorInformation()
    {
        inspectorDataSource?.reloadData()
        inspectorViewController?.reloadData()
    }
    
    // MARK: - InspectorViewControllerDataSource methods
    
    func numberOfRowsInInspectorViewController(viewController: InspectorViewController) -> Int
    {
        if let inspectorDataSource = self.inspectorDataSource {
            return inspectorDataSource.count
        }
        
        return 0
    }
    
    func inspectorViewController(viewController: InspectorViewController, informationAtIndex index: Int) -> InspectorInformation
    {
        return inspectorDataSource![index]
    }
    
    // MARK: - InspectorBottomViewDelegate methods
    
    func inspectorBottomViewTapped(bottomView: InspectorBottomView)
    {
        let window = UIApplication.sharedApplication().keyWindow!
        
        // Configuration
        inspectorViewController = InspectorViewController()
        inspectorViewController!.dataSource = self
        inspectorViewController!.delegate = self
        inspectorNavigationController = UINavigationController(rootViewController: inspectorViewController!)
        
        // Prepare animation
        var initialFrame = window.bounds
        let finalFrame = initialFrame
        initialFrame.origin.y = CGRectGetHeight(window.bounds)
        inspectorNavigationController!.view.frame = initialFrame
        window.addSubview(inspectorNavigationController!.view)
        
        // Animate
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.inspectorNavigationController!.view.frame = finalFrame
        })
    }
    
    func contentToDisplayInInspectorBottomView(bottomView: InspectorBottomView) -> String?
    {
        if let dataSource = self.inspectorDataSource {
            return dataSource.excerptContent
        }
        
        return nil
    }
    
    // MARK: - InspectorViewControllerDelegate methods
    
    func dismissInspectorViewController(viewController: InspectorViewController, animated: Bool)
    {
        if inspectorNavigationController == nil {
            return
        }
        let navigationController = self.inspectorNavigationController!
        
        // Remove inspector navigation controller from view
        if animated
        {
            let window = UIApplication.sharedApplication().keyWindow!
            
            // Prepare animation
            var finalFrame = navigationController.view.frame
            finalFrame.origin.y = CGRectGetHeight(window.bounds)
            
            // Animate
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                navigationController.view.frame = finalFrame
                }, completion: { (finished: Bool) -> Void in
                    navigationController.view.removeFromSuperview()
            })
        }
        else
        {
            navigationController.view.removeFromSuperview()
        }
        
        // Reset inspector bottom view to close state
        inspectorBottomView?.toggle()
    }
    
    // MARK: - Associated objects
    
    private struct AssociatedKeys {
        static var InspectorBottomView = "bbs_InspectorBottomView"
        static var InspectorDataSource = "bbs_InspectorDataSource"
        static var InspectorViewController = "bbs_InspectorViewController"
        static var InspectorNavigationController = "bbs_InspectorNavigationController"
    }
    
    private var inspectorBottomView: InspectorBottomView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.InspectorBottomView) as? InspectorBottomView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.InspectorBottomView, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    private var inspectorDataSource: InspectorDataSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.InspectorDataSource) as? InspectorDataSource
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.InspectorDataSource, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    private var inspectorViewController: InspectorViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.InspectorViewController) as? InspectorViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.InspectorViewController, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    private var inspectorNavigationController: UINavigationController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.InspectorNavigationController) as? UINavigationController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.InspectorNavigationController, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
}