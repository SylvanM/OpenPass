//
//  PasswordCollectionViewCell.swift
//  OpenPass Communication
//
//  Created by Sylvan Martin on 2/11/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import UIKit

/// Cell class for a cell in the password collection view
///
/// This controls the appearance and behavior of the cell
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
