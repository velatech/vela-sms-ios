//
//  VelaUtil.swift
//  vela.ios
//
//  Created by Igbalajobi Elias on 3/25/19.
//  Copyright © 2019 Vela. All rights reserved.
//

import UIKit


class VCSUtil{
    public static func callNumber(phoneNumber: String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            
            let phoneCallUrlURL = phoneCallURL as URL
            if (application.canOpenURL(phoneCallUrlURL)) {
                application.open(phoneCallUrlURL, options: [:]) { (finished) in}
            }
        }
    }
    
    internal static func generateIVString() -> String{
        let flag:Int64 = 0xFFFFFFFFFFFFF
        let currentTime = Int64(Date.timeInMilli) | flag
        let currentTimeString = "\(currentTime)"
        return currentTimeString
    }
}



