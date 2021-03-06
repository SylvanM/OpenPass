//
//  Authentication+Process.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/31/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import LocalAuthentication

extension AuthenticationViewController {
    
    func beginAuthenticationProcess() {
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
    
}
