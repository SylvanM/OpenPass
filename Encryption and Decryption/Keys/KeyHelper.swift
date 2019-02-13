//
//  KeyHelper.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import Security
import CoreFoundation

struct KeyHelper {
    
    func generateKey(for tag: Data) -> SecKey? {
        
        let tag = "com.OpenNav.keys.deviceKeys".data(using: .utf8)
        
        let attributes: [String : Any] = [
            kSecAttrKeyType as String:            kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String:      2048,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String:    true,
                kSecAttrApplicationTag as String: tag as Any
            ]
        ]
        
        var error: Unmanaged<CFError>?
        
        let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)
        return privateKey
        
    }
    
}
