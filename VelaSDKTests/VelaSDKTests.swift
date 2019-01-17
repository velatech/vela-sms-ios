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
    var accountCreationStage1: AccountCreationSMSAPI!

    override func setUp() {
        super.setUp()
        
        
        initVela(api: API(), isLive: true)
        appIdGenerator = AppIDGenerator()
        accountCreationStage1 = AccountCreationSMSAPI(data: AccountCreationSMSAPI.Data())
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

        
        let data = CashTransferSMSAPI.Data()
        data.accountNo = "1234567890"
        data.amount = 10000
        data.bank = "1234"
        data.pin = Bank.UBA_BANK
        data.sourceBankAccountId = "123456"
        data.userId = "12345678"
        
        let cashTransferSMSApi = CashTransferSMSAPI(data: data)
        cashTransferSMSApi.createEncryptedMessage()
        
        
        print(cashTransferSMSApi.validateConfirmationCode(confirmationCode: "123456"))
        
        
        
        
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
