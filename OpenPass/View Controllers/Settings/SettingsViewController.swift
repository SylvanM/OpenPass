//
//  SettingsViewController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/31/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let defaults = UserDefaults.standard
    let settings = UserSettings()
    
    let pickerView = UIPickerView()
    
    var sortingTypes: [String] {
        var temp: [String] = []
        for type in UserSettings.SortingType.allCases {
            temp.append(type.rawValue)
        }
        return temp
    }
    
    // MARK: Properties
    @IBOutlet weak var sortingPicker: UITextField!
    
    // Section constants
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sortingPicker.inputView = pickerView
        sortingPicker.text = (settings.get(setting: .sorting) as! UserSettings.SortingType).rawValue
        
        self.navigationItem.title = "Settings"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return sortingTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingTypes[component]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortingPicker.text = sortingTypes[component]
        let sortMethod = UserSettings.SortingType(rawValue: sortingTypes[component])!
        
        settings.set(sortMethod.rawValue, for: .sorting)
    }

}
