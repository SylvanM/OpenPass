//
//  SingleAccountViewController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController, UITextViewDelegate {
    
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
    
    // Index Constants
    let deleteIndex = IndexPath(row: 0, section: 4)
    
    // Text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var otherInfoField: UITextView!
    
    // Switches
    @IBOutlet weak var shouldHaveSecureTextEntrySwitch: UISwitch!
    
    
    override func viewDidLoad() {
        account.setValue(NSDate(), forKey: "dateAccessed")
        helper.save(account)
        
        super.viewDidLoad()
        self.otherInfoField.delegate = self
        
        tableView.keyboardDismissMode = .interactive

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.editButtonItem.action = #selector(editName)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.name
        
        let decoder = DataDecoder()
        
        // load text fields
        if let key = KeychainHelper().getKey(for: self.keyTag) {
            self.usernameTextField.text = decoder.decode(encodedData: account.username, key: key)
            self.passwordTextField.text = decoder.decode(encodedData: account.password, key: key)
            self.emailTextField.text = decoder.decode(encodedData: account.email, key: key)
            self.otherInfoField.text = decoder.decode(encodedData: account.extraData, key: key)
        }
    }
    
    // MARK: Actions
    
    // Editing endings
    @IBAction func usernameEditingDidEnd(_ sender: Any) {
        save(fromField: sender as! UITextField, name: "username")
    }
    @IBAction func passwordEditingDidEnd(_ sender: Any) {
        save(fromField: sender as! UITextField, name: "password")
    }
    @IBAction func emailEditingDidEnd(_ sender: Any) {
        save(fromField: sender as! UITextField, name: "email")
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
    }
    
    @objc
    func editName() {
        
        // create alert for user
        let changeNamePrompt = UIAlertController(title: "Rename Account", message: nil, preferredStyle: .alert)
        changeNamePrompt.addTextField { (textField) in
            textField.placeholder = "New account name"
            textField.text = self.account.name
            textField.clearButtonMode = .whileEditing
        }
        
        let changeNameAction = UIAlertAction(title: "Change", style: .default) { _ in
            
            if let newName = changeNamePrompt.textFields?[0].text {
                self.helper.changeName(of: self.account.name!, to: newName)
                self.name = newName
            }
            
            // reload view
            self.viewWillAppear(true)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        changeNamePrompt.addAction(changeNameAction)
        changeNamePrompt.addAction(cancelAction)
        
        self.present(changeNamePrompt, animated: true)
    }
    
    // Toggle secure text entry
    @IBAction func userToggledSecureTextEntry(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry = self.shouldHaveSecureTextEntrySwitch.isOn
    }
    
    // MARK: Text View
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.save(fromField: textView as TextHolder, name: "extraData")
    }
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: ", indexPath.section, " ", indexPath.row)
        if indexPath == deleteIndex, let cell = tableView.cellForRow(at: indexPath) {
            
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
    
    func save(fromField textField: TextHolder, name: String) {
        if let textToSave = textField.storedText {
            let encoder = DataEncoder()
            var dataToSave: NSData
            
            let keychain = KeychainHelper()
            let key = keychain.getKey(for: self.keyTag)!
            
            dataToSave = encoder.encode(string: textToSave, key: key)
            
            account.setValue(dataToSave, forKey: name)
            helper.save(account)
        }
    }
    
}
