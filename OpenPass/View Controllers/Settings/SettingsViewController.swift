//
//  SettingsViewController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/31/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    
    // Section constants
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func clearMarkFromAllCells(in section: Int) {
        for i in 0..<tableView.numberOfRows(inSection: section) {
            tableView.cellForRow(at: IndexPath(row: i, section: section))?.accessoryType = .none
        }
    }

}
