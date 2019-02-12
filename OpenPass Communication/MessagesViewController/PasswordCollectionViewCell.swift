//
//  PasswordCollectionViewCell.swift
//  OpenPass Communication
//
//  Created by Sylvan Martin on 2/11/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import UIKit

class PasswordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var account: Account!
    
    var selectedClosure: ((Account) -> ())!
    
    override var isSelected: Bool {
        didSet {
            selectedClosure(account)
        }
    }
    
}
