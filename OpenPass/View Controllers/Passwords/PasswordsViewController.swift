//
//  AccountsViewController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit
import CoreData

class PasswordsViewController: UITableViewController {
    
    // if opening app from extension
    var inheritedAccount: [String : Any]?
    
    let helper = CDHelper()
    var managedContext: NSManagedObjectContext {
        return helper.managedContext
    }
    
    var filteredPasswords = [String]() // variable for password names after search
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var passwordList: [String] {
        if let names = helper.fetchNames() {
            return names
        } else {
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Passwords"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appReopened), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func appReopened() {
        // go back to the authorization view
        performSegue(withIdentifier: "unwindToAuthorization", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload table view
        tableView.reloadData()
        
        if let new = self.inheritedAccount {
            addPassword(self)
        } else {
            print("no new account")
        }
    }
    
    // MARK: Actions
    
    @IBAction func addPassword(_ sender: Any) {
        let alertController = UIAlertController(title: "Name the account", message: "e.g. \"Email\" or \"School Login\"", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Account name"
        }
        
        let addClosure: ([String : Any]) -> () = { accountProperties in
            
            // also generate a new key
            let keyHelper = KeyHelper()
            let tagString = "com.OpenPass.keys." + (accountProperties["name"] as! String) + "key"
            let tag = tagString.data(using: .utf8)!
            let key = keyHelper.generateKey(for: tag)!
            
            // save new object
            let accountDescription = NSEntityDescription.entity(forEntityName: "Account", in: self.managedContext)
            let newAccount = NSManagedObject(entity: accountDescription!, insertInto: self.managedContext) as! Account
            
            // encrypt everything that needs to be encrypted
            
            let processedProperties: [String : Any] = [
                "name": accountProperties["name"]!, // doesn't need to be encrypted
                "dateAccessed": accountProperties["dateAccessed"] ?? NSDate(), // doesn't need to be encrypted
                "extraData": (accountProperties["extraData"] as? Data)?.encrypt(key: key) as Any,
                "email": (accountProperties["email"] as? Data)?.encrypt(key: key) as Any,
                "username": (accountProperties["username"] as? Data)?.encrypt(key: key) as Any,
                "password": (accountProperties["password"] as? Data)?.encrypt(key: key) as Any
            ]
            
            for (name, value) in processedProperties {
                if let data = value as? Data {
                    newAccount.setValue(data, forKey: name)
                } else if name == "name" {
                    newAccount.setValue(value as! String, forKey: name)
                } else if name == "dateAccessed" {
                    newAccount.setValue(value as! Date, forKey: name)
                }
            }
            
            // save key
            let keychain = KeychainHelper()
            print("Saving: ", key)
            print("For tag: ", String(data: tag, encoding: .utf8)!)
            keychain.saveKey(key, for: tag)
            
            self.helper.save(newAccount)
            self.inheritedAccount = nil // prevent from doing this all again
            
            self.tableView.reloadData()
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let name = alertController.textFields?[0].text {
                let properties: [String : Any] = [
                    "name": name
                ]
                
                addClosure(properties)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        if let accountProperties = self.inheritedAccount {
            
            print("Doing stuff")
            addClosure(accountProperties)
            
            // no need to run the rest of this function!
            return
        }
        
        self.present(alertController, animated: true) {
            // user made the account
        }
    }
    
    // MARK: Storyboard
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAccount" {
            if let vc = segue.destination as? AccountViewController {
                if let selectedCell = tableView.cellForRow(at: sender as! IndexPath) as? PasswordCell {
                    vc.name = selectedCell.name.text
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPasswords.count
        }
        
        return passwordList.count
    }
    
    // MARK: Table view actions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openAccount", sender: indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! PasswordCell
        let password: String
        
        if isFiltering() {
            password = filteredPasswords[indexPath.row]
        } else {
            password = passwordList[indexPath.row]
        }

        cell.name.text = password
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! PasswordCell
//
//        cell.name.text = passwordList[indexPath.row]
//
//        return cell
    }
    
    // MARK: Search
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredPasswords = passwordList.filter({( name : String) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        print(filteredPasswords)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
