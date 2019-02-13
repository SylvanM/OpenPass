//
//  DataEncoder.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

/// Structure to encode and encrypt data to be stored in the CoreDataStack
struct DataEncoder {
    
    /**
     Encrypts saved NSData and returns it as a Data object
     
     - Parameters:
        - plain: Plain encoded data needing to be stored
        - key: Encryption key
     */
    func encrypt(_ plainData: Data, key: SecKey) -> NSData {
        print("Plain data: ", plainData)
        let encrypted = plainData.encrypt(key: key)! as NSData
        print("Encrypted: ", encrypted)
        return encrypted
    }
    
    /**
     Encodes plain string and returns it as encrypted NSData
     It will call the encrypt(_:_:) function to encrypt the data with the provided key
     
     - Parameters:
        - string: String to be encoded and encrypted
        - key: Decryption Key
     */
    func encode(string: String, key: SecKey) -> NSData {
        let encoded = string.data(using: .utf8)!
        let encrypted = encrypt(encoded, key: key)
        return encrypted
    }
    
}
