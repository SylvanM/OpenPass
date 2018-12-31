//
//  SingleAccountViewController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    // MARK: Properties
    var account: Account?
    var name: String!
    
    // Text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .interactive

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.name
    }
    
    // MARK: Actions
    
    // Editing endings
    @IBAction func usernameEditingDidEnd(_ sender: Any) {
        save(fromField: sender as! UITextField)
    }
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        save(fromField: sender as! UITextField)
    }
    @IBAction func emailEditingDidEnd(_ sender: Any) {
        save(fromField: sender as! UITextField)
    }
    
    // Primary actions
    @IBAction func usernamePrimaryActionTriggered(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func passwordPrimaryActionTriggered(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func emailPrimaryActionTriggered(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: Methods
    
    func save(fromField textField: UITextField) {
        if let textToSave = textField.text {
            switch textField {
            case usernameTextField:
                // save username
                print("saving username ", textToSave)
                break
            case passwordTextField:
                // save password
                print("saving password ", textToSave)
                break
            default:
                // this code should never be called
                print("something has gone horribly wrong")
            }
        }
    }
    
}
