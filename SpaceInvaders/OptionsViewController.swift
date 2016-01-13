//
//  OptionsViewController.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 12/26/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension OptionsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section {
        case 0, 1:
            rows = 3
        default:
            break
        }
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (0, 1), (0, 2), (0, 0), (1, 1), (2, 2):
            cell = tableView.dequeueReusableCellWithIdentifier("PickerViewCell")!
        default:
            break
        }
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "Control Scheme"
        case 1:
            title = "Control Size"
        default:
            break
        }
        return title
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Both Sides"
            case 1:
                cell.textLabel?.text = "Left Side"
            case 2:
                cell.textLabel?.text = "Right Side"
            default:
                break
            }
            if indexPath.row == currentControlScheme.rawValue {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Small"
            case 1:
                cell.textLabel?.text = "Medium"
            case 2:
                cell.textLabel?.text = "Large"
            default:
                break
            }
            // convert control size to compare it with the row
            let divisor = 25
            if indexPath.row == (currentControlSize.rawValue - ControlSize.Small.rawValue) / divisor {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
    }
    
}

extension OptionsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                currentControlScheme = .BothSides
            case 1:
                currentControlScheme = .LeftSide
            case 2:
                currentControlScheme = .RightSide
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                currentControlSize = .Small
            case 1:
                currentControlSize = .Medium
            case 2:
                currentControlSize = .Large
            default:
                break
            }
        }
        tableView.reloadData()
    }
    
}
