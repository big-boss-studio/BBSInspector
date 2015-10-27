//
//  BBSInspectorViewController.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

let BBSInspectorViewControllerStatusBarStyle = UIStatusBarStyle.Default

internal class BBSInspectorViewController: UITableViewController
{
    /**
    Close bar button item. Tapping on it will try close this view controller
    */
    lazy private var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "close")
        }()
    
    /**
    Store application status bar style to reapply it when inspector is closed
    */
    private var previousStatusBarStyle: UIStatusBarStyle = BBSInspectorViewControllerStatusBarStyle
    
    /**
    Data source
    */
    internal var dataSource: BBSInspectorViewControllerDataSource?
    
    /**
    Delegate
    */
    internal var delegate: BBSInspectorViewControllerDelegate?
    
    // MARK: - Initializers
    
    override internal init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override internal init(style: UITableViewStyle)
    {
        super.init(style: style)
    }
    
    required internal init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Inspector"
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        previousStatusBarStyle = UIApplication.sharedApplication().statusBarStyle
        if previousStatusBarStyle != BBSInspectorViewControllerStatusBarStyle {
            UIApplication.sharedApplication().setStatusBarStyle(BBSInspectorViewControllerStatusBarStyle, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let dataSource = dataSource {
            return dataSource.numberOfRowsInInspectorViewController(self)
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "CellID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) 
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if let dataSource = dataSource {
            let information = dataSource.inspectorViewController(self, informationAtIndex: indexPath.row)
            cell?.accessoryType = information.action != nil ? UITableViewCellAccessoryType.DisclosureIndicator : UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if let dataSource = dataSource {
            let information = dataSource.inspectorViewController(self, informationAtIndex: indexPath.row)
            cell.textLabel?.text = information.title
            cell.detailTextLabel?.attributedText = information.attributedCaption
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let dataSource = dataSource {
            let information = dataSource.inspectorViewController(self, informationAtIndex: indexPath.row)
            information.executeAction(self)
        }
    }
    
    // MARK: - Data management
    
    internal func reloadData()
    {
        self.tableView.reloadData()
    }
    
    // MARK: - UI Actions
    
    internal func close()
    {
        if previousStatusBarStyle != BBSInspectorViewControllerStatusBarStyle {
            UIApplication.sharedApplication().setStatusBarStyle(previousStatusBarStyle, animated: true)
        }
        
        delegate?.dismissInspectorViewController(self, animated: true)
    }
}

protocol BBSInspectorViewControllerDataSource
{
    /**
    Called when preparing the table view of a InspectorViewController object
    
    - parameter viewController: The InspectorViewController controller asking for data count
    - returns: The number of rows to display
    */
    func numberOfRowsInInspectorViewController(viewController: BBSInspectorViewController) -> Int
    
    /**
    Called before displaying a InspectorInformation in table view
    
    - parameter viewController: The InspectorViewController object asking for data
    - parameter index: The index of the asked information
    - returns: The InspectorInformation object to be displayed for this given index
    */
    func inspectorViewController(viewController: BBSInspectorViewController, informationAtIndex index: Int) -> BBSInspectorInformation
}

protocol BBSInspectorViewControllerDelegate
{
    /**
    Called when user touch the cancel button and want to dismiss this view
    
    - parameter viewController: The InspectorViewController that needs to be dismissed
    - parameter animated: Wether or not it should use animation
    */
    func dismissInspectorViewController(viewController: BBSInspectorViewController, animated: Bool)
}

