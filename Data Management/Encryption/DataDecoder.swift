//
//  DataDecryptor.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

/// Structure to decode and decrypt data as a string to be stored or retrieved
struct DataDecoder {
    
    /**
     Decrypts saved NSData and returns it as a Data object
     
     - Parameters:
        - nscipherData: Data retrieved from the CoreDataStack that needs to be decrypted
        - key: Decryption key
    */
    func decrypt(_ nscipherData: NSData, key: SecKey) -> Data? {
        let decrypted = (nscipherData as Data).decrypt(key: key)
        return decrypted
    }
    
    /**
     Decodes encoded and encrypted NSData and returns the string it represents.
     It will call the decrypt(_:_:) function to decrypt the data with the provided key
     
     - Parameters:
        - encodedData: Data to be decrypted and decoded
        - key: Decryption Key
    */
    func decode(encodedData: NSData?, key: SecKey) -> String? {
        
        if let encoded = encodedData, let decrypted = decrypt(encoded, key: key) {
            let decoded = String(data: decrypted, encoding: .utf8)
            return decoded
        } else {
            return nil
        }
    }
    
}
