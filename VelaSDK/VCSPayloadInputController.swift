//
//  VCSPayloadInputController.swift
//  vela.ios
//
//  Created by Igbalajobi Elias on 3/20/19.
//  Copyright © 2019 Vela. All rights reserved.
//

import UIKit
import PopupDialog

class VCSPayloadInputController: UIViewController, UITextViewDelegate{
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var payloadTextView: UITextView!
    @IBOutlet weak var timerLabel: UILabel!

    private var requestCode = 0
    
    var timerCountdown = 120
    private var timer = Timer()
    private let uiPasteboardObserver = UIPasteboardObserver()
    
    private var style: VCSPayloadInputStyle = VCSPayloadInputStyle()
    public var delegate: VCSPayloadInputDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        submitButton.setBackgroundImage(UIImage.from(color: style.accentColor), for: .normal)
        submitButton.setBackgroundImage(UIImage.from(color: style.buttonDisabledColor), for: .disabled)
        submitButton.setTitleColor(style.buttonTextColor, for: .normal)
        timerLabel.textColor = style.accentColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payloadTextView.delegate = self
        submitButton.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        timerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapTimerLabel)))
    }
    
    @objc func onTapTimerLabel(label: UILabel){
        if self.timerCountdown <= 0{self.delegate?.payloadRequestResendSMS(self, self.requestCode)}
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc func updateTimer(){
        if uiPasteboardObserver.isChanged && timer.isValid{
            payloadTextView.text = uiPasteboardObserver.string ?? ""
            submitButton.isEnabled = true
            timer.invalidate()
        }
        
        timerCountdown -= 1
        timerLabel.text = "Wait \(timeString(time: TimeInterval(timerCountdown)))"
        
        if timerCountdown <= 0 || !timer.isValid{
            timer.invalidate(); timerLabel.text = "RESEND SMS"
        }
    }
    
    @IBAction func onTapSubmit(_ sender: UIButton) {
        let text = clean(text: payloadTextView.text)
        delegate?.payloadInputController(self, didFinishWith: .SUCCESS, text: text, requestCode)
    }
    
    private func clean(text: String) -> String{
        return text.replacingOccurrences(of: " \n-VCS-", with: "")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count > 1{
            submitButton.isEnabled = true
            timer.invalidate()
        }else{
            submitButton.isEnabled = false
        }
        
        return true
    }
    
    private class UIPasteboardObserver{
        private let pasteboard = UIPasteboard.general
        private var changeCount = 0
        
        init() {changeCount = pasteboard.changeCount}
        
        var isChanged: Bool {return pasteboard.changeCount != changeCount}
        
        var string: String? {return pasteboard.hasStrings ? pasteboard.string : nil}
    }
    
    static func launchAsDialog(_ caller: UIViewController, requestCode: Int, _ style: VCSPayloadInputStyle = VCSPayloadInputStyle()) -> VCSPayloadInputController{
        let controller = VCSPayloadInputController(nibName: "VCSPayloadInputController", bundle: nil)
        controller.requestCode = requestCode
        controller.style = style
        
        caller.present(PopupDialog(viewController: controller), animated: true, completion: nil)
        return controller
    }
}

public class VCSPayloadInputStyle{
    public var accentColor = UIColor(hex: "#0678D4")
    public var buttonDisabledColor = UIColor(hex: "#CCCCCC")
    public var buttonTextColor = UIColor.white
}

enum VCSPayloadInputResult{ case SUCCESS, FAILED, CANCEL }

protocol VCSPayloadInputDelegate {
    func payloadInputController(_ controller: VCSPayloadInputController, didFinishWith result: VCSPayloadInputResult, text: String?, _ requestCode: Int)
    
    func payloadRequestResendSMS(_ controller: VCSPayloadInputController, _ requestCode: Int)
}



