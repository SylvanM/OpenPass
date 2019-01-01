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
    let moc    = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let helper = CDHelper()
    
    var keyTag: Data {
        let tagString = "com.OpenPass.keys." + self.name! + "key"
        return tagString.data(using: .utf8)!
    }
    
    //var account: Account?
    var name: String!
    var account: Account { // object the view presents
        return helper.fetch(self.name)!
    }
    
    // Section Constants
    let deleteSection = 3
    
    // Text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var shouldEncryptSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .interactive

        shouldEncryptSwitch.setOn(self.account.shouldEncrypt, animated: false)
        
        
        // add switch

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.name
        
        let decoder = DataDecoder()
        
        // load text fields
        if self.account.shouldEncrypt {
            if let key = KeychainHelper().getKey(for: self.keyTag) {
                self.usernameTextField.text = decoder.decode(encodedData: account.username, key: key)
                self.passwordTextField.text = decoder.decode(encodedData: account.password, key: key)
                self.emailTextField.text = decoder.decode(encodedData: account.email, key: key)
            }
        } else {
            if let username = account.username {
                self.usernameTextField.text = String(data: username as Data, encoding: .utf8)
            }
            if let password = account.password {
                self.passwordTextField.text = String(data: password as Data, encoding: .utf8)
            }
            if let email = account.email {
                self.emailTextField.text = String(data: email as Data, encoding: .utf8)
            }
        }
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
    
    // Switch
    @IBAction func switchWasToggled(_ sender: Any) {
        self.account.shouldEncrypt = self.shouldEncryptSwitch.isOn
        
        // resave
        
        save(fromField: usernameTextField)
        save(fromField: passwordTextField)
        save(fromField: emailTextField)
    }
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == deleteSection, indexPath.row == 1, let cell = tableView.cellForRow(at: indexPath) {
            
            // is the user SURE they wanna delete it??
            
            let confirmController = UIAlertController(title: "Are you sure?", message: "This cannot be undone", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.helper.delete(self.account)
                let keychain = KeychainHelper()
                keychain.delete(self.keyTag)
                self.navigationController?.popViewController(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            confirmController.addAction(deleteAction)
            confirmController.addAction(cancelAction)
            
            self.present(confirmController, animated: true) {
                cell.setSelected(false, animated: true)
            }
        }
    }
    
    // MARK: Methods
    
    func save(fromField textField: UITextField) {
        if let textToSave = textField.text {
            let encoder = DataEncoder()
            
            var valueName: String!
            var dataToSave: NSData
            
            // set the key
            switch textField {
            case usernameTextField:
                valueName = "username"
            case passwordTextField:
                valueName = "password"
            case emailTextField:
                valueName = "email"
            default:
                // this code should never be called
                print("something has gone horribly wrong")
            }
            
            if self.account.shouldEncrypt {
                let keychain = KeychainHelper()
                let key = keychain.getKey(for: self.keyTag)!
                
                dataToSave = encoder.encode(string: textToSave, key: key)
            } else {
                dataToSave = textToSave.data(using: .utf8)! as NSData
            }
            
            account.setValue(dataToSave, forKey: valueName)
            helper.save(account)
            
        }
    }
    
}
