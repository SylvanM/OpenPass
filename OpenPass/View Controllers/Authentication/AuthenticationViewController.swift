//
//  HomeViewController.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let context = LAContext()
        
        // code to execute once policy is determined
        let authenticate: (LAPolicy) -> () = { policy in
            let reason = "Provide authentication to view your passwords"
            
            context.evaluatePolicy(policy, localizedReason: reason) { (succeeded, error) in
                if succeeded {
                    // authentication succeeded
                    
                    // later, the user will have to provide authentication for this code to run
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "viewAccounts", sender: nil)
                    }
                    
                } else {
                    print("Failed: ", error as Any)
                }
            }
        }
        
        authenticate(.deviceOwnerAuthentication)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAccounts" {
            _ = segue.destination as! UINavigationController
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
