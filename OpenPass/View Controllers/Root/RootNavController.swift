//
//  RootNavController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/14/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import UIKit

class RootNavController: UINavigationController {
    
    let settings = UserSettings()
    
    var inheritedAccount: [String : Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Sending \(inheritedAccount) to PasswordsViewController")
        (self.children.first as? PasswordsViewController)?.inheritedAccount = self.inheritedAccount
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let passwords = segue.destination as? PasswordsViewController {
            passwords.inheritedAccount = self.inheritedAccount
            print("Sending \(inheritedAccount) to PasswordsViewController")
        } else {
            print("Destination:", segue.destination)
        }
        
        self.inheritedAccount = nil // prevent from doing this all again
    }

}
