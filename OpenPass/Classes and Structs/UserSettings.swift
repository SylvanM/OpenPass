//
//  UserSettings.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/13/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

class UserSettings {
    
    var dict: [String : Any] {
        didSet {
            saveSettings()
        }
    }
    
    var filePath: URL
    
    init() {
        filePath = getDocumentsDirectory()
        filePath.appendPathComponent("user_settings.plist")
        
        if let dict = NSDictionary(contentsOf: filePath) {
            self.dict = (dict as Any) as! [String : Any]
        } else {
            // no previous settings set, so generate default settings
            self.dict = [
                Setting.sorting.rawValue: SortingType.alphabetical.rawValue
            ] as [String : Any]
        }
    }
    
    func get(setting: Setting) -> Any {
        // reload data
        _ = UserSettings()
        
        if setting == .sorting {
            let rawValue = self.dict[setting.rawValue] as! String
            return SortingType(rawValue: rawValue)!
        }
        
        return self.dict[setting.rawValue] as Any
    }
    
    func set(_ value: Any, for setting: Setting) {
        self.dict[setting.rawValue] = value
    }
    
    func saveSettings() {
        
        let dictData = NSDictionary(dictionary: self.dict)
        
        do {
            try dictData.write(to: filePath)
        } catch {
            print("error on saving user setting: \(error)")
        }
    }
    
    enum Setting : String, CaseIterable {
        case sorting = "sorting"
    }
    
    // Sorting types
    enum SortingType: String, CaseIterable {
        case alphabetical = "Alphabetical"
        case byDate = "By Date Accessed"
    }
    
}
