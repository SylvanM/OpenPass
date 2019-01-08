//
//  UITextLabel+Holder.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/7/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField: TextHolder {
    var storedText: String? {
        get {
            return self.text
        }
        set (newValue) {
            self.text = newValue
        }
    }
    
    
}
