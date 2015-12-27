//
//  OptionsViewController.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 12/26/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension OptionsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section {
        case 0:
            rows = 3
        default:
            break
        }
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (0, 1), (0, 2):
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
            title = "Controls"
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
        }
    }
    
}
