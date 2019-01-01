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
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let helper = CDHelper()
    
    var passwordList: [String] {
        return helper.fetchNames()!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload table view
        tableView.reloadData()
    }
    
    // MARK: Actions
    
    @IBAction func addPassword(_ sender: Any) {
        let alertController = UIAlertController(title: "Name the account", message: "i.e. \"Email\" or \"School Login\"", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Account name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let name = alertController.textFields?[0].text {
                
                // save new object
                let accountDescription = NSEntityDescription.entity(forEntityName: "Account", in: self.managedContext)
                let newAccount = NSManagedObject(entity: accountDescription!, insertInto: self.managedContext) as! Account
                
                newAccount.setValue(name, forKey: "name")
                
                // also generate a new key
                let keyHelper = KeyHelper()
                var tagString = "com.OpenPass.keys." + name + "key"
                let tag = tagString.data(using: .utf8)!
                let key = keyHelper.generateKey(for: tag)!

                // save key
                let keychain = KeychainHelper()
                print("Saving: ", key)
                print("For tag: ", String(data: tag, encoding: .utf8)!)
                keychain.saveKey(key, for: tag)
                
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
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
        // #warning Incomplete implementation, return the number of rows
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
        
        cell.name.text = passwordList[indexPath.row]
        
        return cell
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
