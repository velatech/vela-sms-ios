//
//  VelaSDKTests.swift
//  VelaSDKTests
//
//  Created by Igbalajobi Elias on 12/8/18.
//  Copyright © 2018 Igbalajobi Elias. All rights reserved.
//

import XCTest
@testable import VelaSDK

class VelaSDKTests: XCTestCase {
    var appIdGenerator: AppIDGenerator!
    var accountCreationStage1: AccountCreationStage1SMSAPI!

    override func setUp() {
        super.setUp()
        
        
        initVela(api: API(), isLive: true)
        appIdGenerator = AppIDGenerator()
        accountCreationStage1 = AccountCreationStage1SMSAPI(data: AccountCreationStage1SMSAPI.Data())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    

    override func tearDown() {
        appIdGenerator = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserIdGenerator() {
        let value = try? appIdGenerator.generateUniqueId(deviceImei: "3543130448382850", smsShortCode: "12345001")
        XCTAssertEqual(value!, "ZhD4mcSoCYo1")
    }
    
    func testSMSAPI(){
        let data =  AccountCreationStage1SMSAPI.Data();
        data.acctNo = "2054121348"
        data.bank = "044"
        data.deviceImei = "0123456789012345"
        data.dialingCode = "234"
        data.password = "1233333"
        data.phone = "8029059420"
        data.pin = "1234"
        accountCreationStage1.data = data
        
        let message  = try? accountCreationStage1.createEncryptedMessage()
        print(message)
        XCTAssertNoThrow(message)
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            testUserIdGenerator()
        }
    }

}

class API: VelaAPI{
    override func merchantSharedCode() -> String? {
        return "05"
    }
}
