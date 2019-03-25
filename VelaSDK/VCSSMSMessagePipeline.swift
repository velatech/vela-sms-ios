//
//  SMSMessagePipeline.swift
//  VelaSDK
//
//  Created by Igbalajobi Elias on 12/9/18.
//  Copyright © 2018 Igbalajobi Elias. All rights reserved.
//

import UIKit

public class VCSSMSMessagePipeline<T: Codable>: SMSMessageProtocol{
    internal var data: T!
    internal var stamp: String!
    
    private var targetSystem: Int!
    private var appId: String!
    private var appEncryptionKey: String!
    
    public init(_ data: T, _ targetSystem: Int, _ appId: String = VCSAppId, _ appEncryptionKey: String = VCSAppEncryptionKey) {
        self.data = data
        self.targetSystem = targetSystem
        self.appId = appId
        self.appEncryptionKey = appEncryptionKey
    }
    
    private func toVCSDataStructure(encryptedText: String) -> String{
        let sharedServiceCode = (VCSMerchantSharedCode != nil) ? VCSMerchantSharedCode : "0"
        
        let vcsRequest = "\(sharedServiceCode!)!\(targetSystem!)!\(appId!)!\(encryptedText)"
        
        print("Hello \(vcsRequest)")
        return vcsRequest
    }
    
    public func createEncryptedMessage() -> String {
        let messageTransmission = MessageTransmission.getInstance(secretKey: appEncryptionKey)
        
        self.stamp = generatedStamp()
        let text = compressedMessageStructure(stamp: stamp)
        let iv = VCSUtil.generateIVString()
        
        let encryptedMessage =  try! messageTransmission.aesEncrypt(text: text, iv: iv)

        let vcs = toVCSDataStructure(encryptedText: encryptedMessage)
        
        return VCSSSMSPrefixText + " " + vcs
    }

    public func compressedMessageStructure(stamp: String) -> String { return ""}
    
    public func getOTPServiceCode() -> String?{return nil}
    
    public func getMessageStamp() -> String{return self.stamp}
    
//    public func getSuccessCode() -> String{
//        let stamp = getMessageStamp()
//        return stamp.substring(from: stamp.count - 6)
//    }
//    
//    public func getFailedCode() -> String{
//        return getMessageStamp().substring(to: 6)
//    }
//    
//    public func getOTPRequestCode() -> String{
//        let stamp = getMessageStamp()
//        return stamp.substring(with: 3..<stamp.count-3)
//    }
//    
//    public func validateConfirmationCode(confirmationCode: String) -> ConfirmationMessageResult{
//        if confirmationCode.elementsEqual(getSuccessCode()){
//            return ConfirmationMessageResult.REQUEST_SUCCESSFUL
//        } else if confirmationCode.elementsEqual(getFailedCode()){
//            return ConfirmationMessageResult.REQUEST_FAILED
//        }else if confirmationCode.elementsEqual(getOTPRequestCode()){
//            return ConfirmationMessageResult.OTP_REQUIRED
//        }else{
//            return ConfirmationMessageResult.UNRESOLVED
//        }
//    }
    
    
}

public struct VCSTargetSystem{
    public static var MERCHANT = 0
    public static var VCS_SYSTEM = 1
    public static var ENCRYPTION_KEY_UPDATE = 2
}

public enum ConfirmationMessageResult{
    case REQUEST_SUCCESSFUL
    case REQUEST_FAILED
    case OTP_REQUIRED
    case UNRESOLVED
}

public var deviceAppImei: Int {
    let identifier = UIDevice.current.identifierForVendor!.uuidString
    let splitted = identifier.split(separator: "-")
    
    var stringIndentifier = String((Int(splitted[splitted.count-1], radix: 16))!);
    stringIndentifier = "1111111111111111\(stringIndentifier)"
    stringIndentifier = stringIndentifier.substring(from: stringIndentifier.count-16)
    
    return Int(stringIndentifier)!
}

public protocol SMSMessageProtocol {
    func createEncryptedMessage() throws -> String;
}

public func encodeObjectToJSON<T: Codable>(data: T) throws -> String{
    let encoder = JSONEncoder()
    return String(data: try encoder.encode(data), encoding: .utf8)!
}

public func generatedStamp() -> String {
    let date = Int64(Date.timeInMilli)       //system date
    let intIndentifier = Int64(deviceAppImei)     //identifier
    let value = "111111111111\(String(intIndentifier & date))"
    return value.substring(from: value.count-12)
}

public func decodeJSONToObject<T: Codable>(json: String) throws -> T{
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: json.data(using: .utf8)!)
}

let smsAlertDialogTitle = "Alert"
let SMS_DIALOG_MESSAGE = APPMessages.SMSAwareNotification
let smsAlertPostivieButton = "OK"
let SMS_NS_MESSAGE = APPMessages.SMSSendFailed ?? ""
