//
//  KeychainHelper.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

struct KeychainHelper {
    
    func getKey(for tag: Data) -> SecKey? {
        print("Getting key: ", String(data: tag, encoding: .utf8)!)
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                       kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            print("Could not get key: ", status)
            
            return nil
        }
        let key = item as! SecKey
        
        return key
    }
    
    func saveKey(_ key: SecKey, for tag: Data) {
        let tagString = String(data: tag, encoding: .utf8)!
        print("Saving key: ", tagString)
        
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueRef as String: key]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        do {
            guard status == errSecSuccess else { throw KeychainError.couldNotSave }
        } catch {
            print("could not save: ", error)
        }
        
    }
    
    func delete(_ keyTag: Data) {
        let tagString = String(data: keyTag, encoding: .utf8)!
        print("Deleting: ", tagString)
        
        if let key = getKey(for: keyTag) {
            let query: [String : Any] = [kSecClass as String: kSecClassKey,
                                        kSecAttrApplicationTag as String: keyTag,
                                        kSecValueRef as String: key]
            
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound else { print("Could not delete"); return }
        }
    }
    
    func changeTag(of original: Data, to newTag: Data) {
        
        // to solve this, we will simply create a new key original to the original key,
        // change the tag, delete the old one, and save the new one
        
        if let key = getKey(for: original) {
            delete(original)
            saveKey(key, for: newTag)
        }
        
        // if the condition above is not met, the original key didn't exist to begin with
        
    }
    
    enum KeychainError: Error {
        case couldNotSave
        case couldNotDelete
    }
    
}
