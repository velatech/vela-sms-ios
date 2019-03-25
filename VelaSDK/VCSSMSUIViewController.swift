//
//  SMSUIViewController.swift
//  VelaSDK
//
//  Created by Igbalajobi Elias on 1/16/19.
//  Copyright © 2019 Igbalajobi Elias. All rights reserved.
//

import MessageUI

open class VCSSMSUIViewController: UIViewController, MFMessageComposeViewControllerDelegate, VCSPayloadInputDelegate{
    private var messageComposerRequestCode = 0
    private var ENRYPTION_KEY_REQUEST_CODE: Int = 0x234A
    
    open func sendRequest(encryptedMessage: String, _ requestCode: Int = 0){
        let alert = UIAlertController(title: smsAlertDialogTitle, message: SMS_DIALOG_MESSAGE, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: smsAlertPostivieButton, style: .default, handler:{
            if $0.style == .default{
                self.messageComposerRequestCode = requestCode
                let smsMessageComposer =  SMSMessageComposer(encryptedMessage, VCSSMSAPIShortCode, self)
                smsMessageComposer.present(viewController: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    open func sendRequest<T: Codable>(message: VCSSMSMessagePipeline<T>,  _ requestCode: Int = 0){
        sendRequest(encryptedMessage: message.createEncryptedMessage(), requestCode)
    }
    
    open func smsRequestSent(controller: MFMessageComposeViewController, result: MessageComposeResult, _ requestCode: Int){
    }
    
    public func launchVCSPayloadInputController(){
        let controller = VCSPayloadInputController.launchAsDialog(self, requestCode: messageComposerRequestCode)
        controller.delegate = self
    }
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        
        switch messageComposerRequestCode {
        case ENRYPTION_KEY_REQUEST_CODE:
            launchVCSPayloadInputController()
        default:
            smsRequestSent(controller: controller, result: result, messageComposerRequestCode)
        }
    }
    
    public func requestEncryptionKeyUpdate(){
        if VCSOfflineUserPreference.appEncryptionKey == nil || VCSOfflineUserPreference.appId == nil{
            let data = EncryptionKeyRequestSMSAPI.Data(deviceImei: String(deviceAppImei))
            sendRequest(message: EncryptionKeyRequestSMSAPI(data: data), ENRYPTION_KEY_REQUEST_CODE)
        }else{
            NSLog("%s", "VCS Encryption Key Request Done")
        }
    }
    
    func payloadRequestResendSMS(_ controller: VCSPayloadInputController, _ requestCode: Int) {
        if messageComposerRequestCode == ENRYPTION_KEY_REQUEST_CODE{
            controller.dismiss(animated: true, completion: nil)
            self.requestEncryptionKeyUpdate()
        }
    }
    
    func payloadInputController(_ controller: VCSPayloadInputController, didFinishWith result: VCSPayloadInputResult, text: String?, _ requestCode: Int) {
        
        if requestCode == ENRYPTION_KEY_REQUEST_CODE{
            controller.dismiss(animated: true, completion: nil)
            
            do{
                let response = try EncryptionKeyResponseHandler(message: text!)
                VCSOfflineUserPreference.appEncryptionKey = response.appEncryptionKey
                VCSOfflineUserPreference.appId = response.appId
            }catch{
            }
        }
    }
}
