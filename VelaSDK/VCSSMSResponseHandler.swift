//
//  VCSResponseManager.swift
//  vela.ios
//
//  Created by Igbalajobi Elias on 3/20/19.
//  Copyright © 2019 Vela. All rights reserved.
//

import Foundation

open class VCSSMSResponseHandler{
    public var result: String?
    public var data: String?
    
    init(message: String) throws {
        let splitted = message.split(separator: "!")
        result = String(splitted[0])
        data = String(splitted[splitted.count-1])
    }
}

public class EncryptionKeyResponseHandler: VCSSMSResponseHandler{
    public var appId: String?
    public var appEncryptionKey: String?
    
    override init(message: String) throws {
        try super.init(message: message)
        
        if let data = data{
            let mt = MessageTransmission.getInstance(secretKey: VCSDefaultEncryptionKey)
            let decryptedText = try mt.aesDecrypt(encryptedText: data)
            
            let splitted = decryptedText.split(separator: "!")
            appId = String(splitted[0])
            appEncryptionKey = String(splitted[1])
        }
    }
}
