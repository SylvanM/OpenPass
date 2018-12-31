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
        beginAuthenticationProcess()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAccounts" {
            _ = segue.destination as! UINavigationController
        }
    }
    
    // MARK: Actions
    
    @IBAction func userWantsToAuthenticate(_ sender: Any) {
        beginAuthenticationProcess()
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
