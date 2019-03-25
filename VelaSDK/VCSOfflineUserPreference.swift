//
//  VelaOfflineUserPreference.swift
//  vela.ios
//
//  Created by Igbalajobi Elias on 3/20/19.
//  Copyright © 2019 Vela. All rights reserved.
//

import Foundation

class VCSOfflineUserPreference{
    private static let userDefault = UserDefaults(suiteName: "VelaOfflineUserPreference")!
    
    
    static var appId: String?{
        get{return userDefault.string(forKey: "appId")}
        set(value){userDefault.set(value, forKey: "appId")}
    }
    
    static var appEncryptionKey: String?{
        get{return userDefault.string(forKey: "appEncryptionKey")}
        set(value){userDefault.set(value, forKey: "appEncryptionKey")}
    }
    
    static func clear(){
        let dictionary = userDefault.dictionaryRepresentation()
        dictionary.keys.forEach { key in userDefault.removeObject(forKey: key)}
        print(Array(userDefault.dictionaryRepresentation().keys).count)
    }
}
