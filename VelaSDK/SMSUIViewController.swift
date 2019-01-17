//
//  SMSUIViewController.swift
//  VelaSDK
//
//  Created by Igbalajobi Elias on 1/16/19.
//  Copyright © 2019 Igbalajobi Elias. All rights reserved.
//

import Foundation
import MessageUI

open class SMSUIViewController: UIViewController, MFMessageComposeViewControllerDelegate{
    open func sendRequest(encryptedMessage: String){
        let alert = UIAlertController(title: SMS_D_TITLE, message: SMS_DIALOG_MESSAGE, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: SMS_D_PBTN, style: .default, handler:{
            if $0.style == .default{
                let composer =  SMSMessageComposer(encryptedMessage, SMS_API_SHORT_CODE, self)
                composer.present(viewController: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    open func sendRequest<T: Codable>(message: SMSMessagePipeline<T>){
        let message = try? message.createEncryptedMessage()
        sendRequest(encryptedMessage: message ?? "")
    }
    
    open func smsRequestSent(controller: MFMessageComposeViewController, result: MessageComposeResult){}
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        smsRequestSent(controller: controller, result: result)
    }
}
