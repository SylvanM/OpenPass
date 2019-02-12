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
    
    var sortingTypes: [String]!
    
    // MARK: Properties
    @IBOutlet weak var sortingPicker: LimitedTextField!
    
    
    // Index Path Constants
    let sortingCellPath = IndexPath(row: 0, section: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        
        // get row of saved value
        let saved = (settings.get(setting: .sorting) as! UserSettings.SortingType).rawValue
        let index = sortingTypes.firstIndex(of: saved)!
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortingTypes = []
        for type in UserSettings.SortingType.allCases {
            sortingTypes.append(type.rawValue)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sortingPicker.inputView = pickerView
        sortingPicker.text = (settings.get(setting: .sorting) as! UserSettings.SortingType).rawValue
        
        self.navigationItem.title = "Settings"
        
        tableView.keyboardDismissMode = .interactive
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // which cell was selected?
        switch indexPath {
            
        case sortingCellPath: // user selected sorting cell
            sortingPicker.becomeFirstResponder()
            let sortingCell = tableView.cellForRow(at: sortingCellPath)
            sortingCell?.setSelected(false, animated: true)
            
        default:
            print("Selected:", indexPath.section, indexPath.row)
        }
        
    }
    
    // MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortingPicker.text = sortingTypes[row]
        let sortMethod = UserSettings.SortingType(rawValue: sortingTypes[row])!
        
        settings.set(sortMethod.rawValue, for: .sorting)
    }

}
