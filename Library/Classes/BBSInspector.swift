//
//  BBSInspector.swift
//  DANON
//
//  Created by Cyril Chandelier on 11/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

@objc public class BBSInspector: BBSInspectorBottomViewDelegate, BBSInspectorViewControllerDataSource, BBSInspectorViewControllerDelegate
{
    lazy private var bottomView: BBSInspectorBottomView = {
        let view = BBSInspectorBottomView()
        view.delegate = self
        return view
    }()
    
    lazy private var inspectorViewController: BBSInspectorViewController = {
        let viewController = BBSInspectorViewController()
        viewController.dataSource = self
        viewController.delegate = self
        return viewController
    }()
    
    lazy private var inspectorNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setViewControllers([self.inspectorViewController], animated: false)
        return navigationController
    }()
    
    /**
    Data source
    */
    public var dataSource: BBSInspectorDataSource = BBSInspectorDataSource()
    
    // MARK: - Shared instance
    
    class public var sharedInstance: BBSInspector {
        struct Singleton {
            static let instance = BBSInspector()
        }
        
        return Singleton.instance
    }
    
    // MARK: - State managament
    
    /**
    Add a inspector component to the bottom of screen to enable Inspector features
    */
    public func enableInspector()
    {
        dataSource.reloadData()
        bottomView.show(inView: UIApplication.sharedApplication().keyWindow!)
    }
    
    /**
    Remove inspector component from screen
    */
    public func disableInspector()
    {
        bottomView.hide()
    }
    
    /**
    Reload inspector content
    */
    public func reloadInspectorInformation()
    {
        dataSource.reloadData()
        inspectorViewController.reloadData()
    }
    
    // MARK: - InspectorViewControllerDataSource methods
    
    func numberOfRowsInInspectorViewController(viewController: BBSInspectorViewController) -> Int
    {
        return dataSource.count
    }
    
    func inspectorViewController(viewController: BBSInspectorViewController, informationAtIndex index: Int) -> BBSInspectorInformation
    {
        return dataSource[index]
    }
    
    // MARK: - InspectorBottomViewDelegate methods
    
    func inspectorBottomViewTapped(bottomView: BBSInspectorBottomView)
    {
        let window = UIApplication.sharedApplication().keyWindow!
        
        // Prepare animation
        var initialFrame = window.bounds
        let finalFrame = initialFrame
        initialFrame.origin.y = CGRectGetHeight(window.bounds)
        inspectorNavigationController.view.frame = initialFrame
        window.addSubview(inspectorNavigationController.view)
        
        // Animate
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.inspectorNavigationController.view.frame = finalFrame
        })
    }
    
    func contentToDisplayInInspectorBottomView(bottomView: BBSInspectorBottomView) -> String?
    {
        return dataSource.excerptContent
    }
    
    // MARK: - InspectorViewControllerDelegate methods
    
    internal func dismissInspectorViewController(viewController: BBSInspectorViewController, animated: Bool)
    {
        let navigationController = self.inspectorNavigationController
        
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
        bottomView.toggle()
    }
}