//
//  MVC+CollectionViewController.swift
//  OpenPass Communication
//
//  Created by Sylvan Martin on 2/11/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Messages

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "password_cell", for: indexPath) as! PasswordCollectionViewCell
        cell.label.text = accounts[indexPath.row].name
        cell.account = accounts[indexPath.row]
        
        cell.selectedClosure = { account in
            let message = MSMessage()
            let layout = MSMessageTemplateLayout()
            layout.caption = account.name
            message.layout = layout
            
            var components = URLComponents()
            
            message.url = components.url!
            
            self.activeConversation?.insert(message, completionHandler: { (error) in
                print("Error:", error as Any)
            })
        }
        
        return cell
    }
    
}
