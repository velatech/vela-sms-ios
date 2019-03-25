//
//  API.swift
//  VelaSDK
//
//  Created by Igbalajobi Elias on 12/8/18.
//  Copyright © 2018 Igbalajobi Elias. All rights reserved.
//

open class VCSAPI{
    public init(){}
    
    open func smsAPIShortCode(isLive: Bool=false) -> String {
        return isLive ? "34461" : "38350"
    }
    
    open func smsAPITextPrefix() -> String { return "VELA"}
    
    open func smsEncryptionKey() -> String {return "*c3ntr@ls3rv1c3#"}
    
    open func messageDefault(type: VelaMessageDefault) -> String{
        switch type {
        case .MESSAGE_APP_NOT_AVAILABLE:
            return "Your device is not able to send text messages"
        case .SMS_AWARE_NOTIFICATION:
            return "Vela will like to send a message to proceed. Tap OK to continue. SMS charge is free"
        case .SMS_SEND_FAILED:
            return "Message couldn't be sent, Please Try again."
        }
    }
    
    open func merchantSharedCode(isLive: Bool=false) -> String? {return isLive ? "8" : "3"}
}
