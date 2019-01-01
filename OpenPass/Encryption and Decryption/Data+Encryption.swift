//
//  Data+Encryption.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import Security

extension Data {
    
    func encrypt(key: SecKey) -> Data? {
        
        var error: Unmanaged<CFError>?
        
        let publicKey =  SecKeyCopyPublicKey(key)!
        
        print("Algorithm supports key: ", SecKeyIsAlgorithmSupported(publicKey, .encrypt, .rsaEncryptionOAEPSHA256AESGCM))
        
        let encryptedCFData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256AESGCM, self as CFData, &error)
        let encryptedData = encryptedCFData as Data?

        print("Encrypted: ", encryptedData)
        return encryptedData
    }
    
    func decrypt(key: SecKey) -> Data? {
        
        var error: Unmanaged<CFError>?
        
        let publicKey =  SecKeyCopyPublicKey(key)!
        
        print("Algorithm supports key: ", SecKeyIsAlgorithmSupported(publicKey, .encrypt, .rsaEncryptionOAEPSHA256AESGCM))
        
        let decryptedCFData = SecKeyCreateDecryptedData(key, .rsaEncryptionOAEPSHA256AESGCM, self as CFData, &error)
        let decryptedData = decryptedCFData as Data?
        
        print("Decrypted: ", decryptedData)
        return decryptedData
        
    }
    
}
