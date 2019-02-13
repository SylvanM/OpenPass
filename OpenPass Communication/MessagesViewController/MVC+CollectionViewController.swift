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
        
        cell.selectedClosure = { encryptedAccount in
            
            // First, decrypt the account
            
            // retrieve the key for the account
            let keychain = KeychainHelper()
            guard let key = keychain.getKey(for: encryptedAccount.name!) else {
                print("Failed to get key for \(encryptedAccount.name!), cancelling...")
                return
            }
            
            // now decrypt the account information
            let decrypted_extraData = (encryptedAccount.extraData as Data?)?.decrypt(key: key)
            let decrypted_email     = (encryptedAccount.email     as Data?)?.decrypt(key: key)
            let decrypted_username  = (encryptedAccount.username  as Data?)?.decrypt(key: key)
            let decrypted_password  = (encryptedAccount.password  as Data?)?.decrypt(key: key)
            
            let message = MSMessage()
            let layout = MSMessageTemplateLayout()
            layout.caption = encryptedAccount.name
            message.layout = layout
            
            var components = URLComponents(string: "openRecievedPassword://")
            
            // make items for query
            var name: String?
            var dateString: String?
            var extraDataString: String?
            var email: String?
            var username: String?
            var password: String?
            
            name = encryptedAccount.name!
            
            // format date into string
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            
            if let date = encryptedAccount.dateAccessed {
                dateString = dateFormatter.string(from: date as Date)
            }
            
            // format extra data into string
            
            extraDataString = decrypted_extraData?.base64EncodedString()
            email           = decrypted_email?.base64EncodedString()
            username        = decrypted_username?.base64EncodedString()
            password        = decrypted_password?.base64EncodedString()
            
            components!.queryItems = [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "dateAccessed", value: dateString),
                URLQueryItem(name: "extraData", value: extraDataString),
                URLQueryItem(name: "email", value: email),
                URLQueryItem(name: "username", value: username),
                URLQueryItem(name: "password", value: password)
            ]
            
            components?.scheme = "openRecievedPassword"
            
            message.summaryText = components!.url?.absoluteString
            
            print("Sending:", message.summaryText as Any)
            
            self.activeConversation?.insert(message, completionHandler: { (error) in
                print("Error:", error as Any)
            })
        }
        
        return cell
    }
    
}
