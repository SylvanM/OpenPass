//
//  PasswordCell.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/31/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class PasswordCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var name: UILabel!
    
    let settings = UserSettings()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(darkTheme), name: NSNotification.Name.enterDarkMode, object: nil)
        notificationCenter.addObserver(self, selector: #selector(lightTheme), name: NSNotification.Name.enterLightMode, object: nil)
        
        switch settings.get(setting: .darkMode) as! Bool {
        case true:
            self.backgroundColor = UIColor.darkGray
            self.name.textColor = UIColor.white
        case false:
            self.backgroundColor = UIColor.lightTheme_tableCell
            self.name.textColor = UIColor.black
        }
        
    }
    
    @objc func darkTheme() {
        self.backgroundColor = UIColor.darkTheme_tableCell
        self.name.textColor = UIColor.darkText
    }
    
    @objc func lightTheme() {
        self.backgroundColor = UIColor.darkTheme_tableCell
        self.name.textColor = UIColor.lightText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
