//
//  InspectorViewController.swift
//  BBSInspector
//
//  Created by Cyril Chandelier on 05/03/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

import Foundation
import UIKit

let InspectorViewControllerStatusBarStyle = UIStatusBarStyle.Default

internal class InspectorViewController: UITableViewController
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
    private var previousStatusBarStyle: UIStatusBarStyle = InspectorViewControllerStatusBarStyle
    
    /**
    Data source
    */
    internal var dataSource: InspectorViewControllerDataSource?
    
    /**
    Delegate
    */
    internal var delegate: InspectorViewControllerDelegate?
    
    // MARK: - Initializers
    
    override internal init()
    {
        super.init()
    }
    
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
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Inspector"
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        previousStatusBarStyle = UIApplication.sharedApplication().statusBarStyle
        if previousStatusBarStyle != InspectorViewControllerStatusBarStyle {
            UIApplication.sharedApplication().setStatusBarStyle(InspectorViewControllerStatusBarStyle, animated: true)
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
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
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
            information.executeAction()
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
        if previousStatusBarStyle != InspectorViewControllerStatusBarStyle {
            UIApplication.sharedApplication().setStatusBarStyle(previousStatusBarStyle, animated: true)
        }
        
        delegate?.dismissInspectorViewController(self, animated: true)
    }
}

protocol InspectorViewControllerDataSource
{
    /**
    Called when preparing the table view of a InspectorViewController object
    
    :param: viewController The InspectorViewController controller asking for data count
    :returns: The number of rows to display
    */
    func numberOfRowsInInspectorViewController(viewController: InspectorViewController) -> Int
    
    /**
    Called before displaying a InspectorInformation in table view
    
    :param: viewController The InspectorViewController object asking for data
    :param: index The index of the asked information
    :returns: The InspectorInformation object to be displayed for this given index
    */
    func inspectorViewController(viewController: InspectorViewController, informationAtIndex index: Int) -> InspectorInformation
}

protocol InspectorViewControllerDelegate
{
    /**
    Called when user touch the cancel button and want to dismiss this view
    
    :param: viewController The InspectorViewController that needs to be dismissed
    :param: animated Wether or not it should use animation
    */
    func dismissInspectorViewController(viewController: InspectorViewController, animated: Bool)
}
