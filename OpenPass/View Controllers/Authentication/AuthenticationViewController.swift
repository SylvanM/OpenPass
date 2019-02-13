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
    
    var newAccount: [String : Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beginAuthenticationProcess()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAccounts" {
            let vc = segue.destination as! RootNavController
            print("Sending \(String(describing: newAccount)) to RootNavController")
            vc.inheritedAccount = self.newAccount
        }
        
        self.newAccount = nil // prevent from doing this all again
    }
    
    // MARK: Actions
    
    @IBAction func userWantsToAuthenticate(_ sender: Any) {
        beginAuthenticationProcess()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
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
