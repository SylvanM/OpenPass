//
//  DataEncoder.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

struct DataEncoder {
    
    func encrypt(_ plainData: Data, key: SecKey) -> NSData {
        print("Plain data: ", plainData)
        let encrypted = plainData.encrypt(key: key)! as NSData
        print("Encrypted: ", encrypted)
        return encrypted
    }
    
    func encode(string: String, key: SecKey) -> NSData {
        let encoded = string.data(using: .utf8)!
        let encrypted = encrypt(encoded, key: key)
        return encrypted
    }
    
}
