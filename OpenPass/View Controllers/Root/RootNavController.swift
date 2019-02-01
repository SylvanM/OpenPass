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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(enterDarkMode), name: .enterDarkMode, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterLightMode), name: .enterLightMode, object: nil)
        
        if let darkMode = settings.get(setting: .darkMode) as? Bool {
            if darkMode {
                enterDarkMode()
            } else {
                enterLightMode()
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func enterDarkMode() {
        print("Entering dark mode")
        self.navigationBar.barStyle = .blackTranslucent
    }
    
    @objc func enterLightMode() {
        print("Entering light mode")
        self.navigationBar.barStyle = .default
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
