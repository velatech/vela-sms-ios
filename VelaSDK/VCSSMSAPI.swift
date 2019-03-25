//
//  AccountCreationSMSAPI.swift
//  VelaSDK
//
//  Created by Igbalajobi Elias on 12/11/18.
//  Copyright © 2018 Igbalajobi Elias. All rights reserved.
//

public class EncryptionKeyRequestSMSAPI: VCSSMSMessagePipeline<EncryptionKeyRequestSMSAPI.Data>{
    public init(data: Data) {
        super.init(data, VCSTargetSystem.VCS_SYSTEM, "0", VCSDefaultEncryptionKey)
    }
    
    public struct Data: Codable {
        public var deviceImei: String!
    }
    
    override public func compressedMessageStructure(stamp: String) -> String {
        return "\(data.deviceImei!)"
    }
}

public enum VelaMessageDefault {
    case MESSAGE_APP_NOT_AVAILABLE, SMS_AWARE_NOTIFICATION, SMS_SEND_FAILED
}

public func initVela(api: VCSAPI = VCSAPI(), isLive: Bool = false){
    VCSSMSAPIShortCode = api.smsAPIShortCode(isLive: isLive)
    VCSSSMSPrefixText = api.smsAPITextPrefix()
    VCSDefaultEncryptionKey = api.smsEncryptionKey()
    VCSMerchantSharedCode = api.merchantSharedCode(isLive: isLive)
    
    APPMessages.messagingAppNotAvailable = api.messageDefault(type: .MESSAGE_APP_NOT_AVAILABLE)
    APPMessages.SMSAwareNotification = api.messageDefault(type: .SMS_AWARE_NOTIFICATION)
    APPMessages.SMSSendFailed = api.messageDefault(type: .SMS_SEND_FAILED)
}


public var VCSSMSAPIShortCode: String!
public var VCSSSMSPrefixText: String!
public var VCSDefaultEncryptionKey: String!
public var VCSAppId: String = VCSOfflineUserPreference.appId!
public var VCSAppEncryptionKey = VCSOfflineUserPreference.appEncryptionKey!
public var VCSMerchantSharedCode: String?

public struct APPMessages{
    static var messagingAppNotAvailable: String!
    static var SMSAwareNotification: String!
    static var SMSSendFailed: String!
}
