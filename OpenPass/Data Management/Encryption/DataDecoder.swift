//
//  DataDecryptor.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

struct DataDecoder {
    
    func decrypt(_ nscipherData: NSData, key: SecKey) -> Data? {
        let decrypted = (nscipherData as Data).decrypt(key: key)
        print("Decrypted: ", decrypted)
        return decrypted
    }
    
    func decode(encodedData: NSData?, key: SecKey) -> String? {
        
        print("Encoded: ", encodedData)
        
        if let encoded = encodedData, let decrypted = decrypt(encoded, key: key) {
            let decoded = String(data: decrypted, encoding: .utf8)
            return decoded
        } else {
            return nil
        }
    }
    
}
