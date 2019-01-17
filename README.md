#  VelaSMS iOS SDK


## Getting Started

Follow the instructions below to get started with `VelaOffline` iOS SDK  


### Installation

#### CocoaPods

[CocoaPod](https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate VelaSDK into your Xcode project using CocoaPods, specify it in your Podfile:
    
    pod 'VelaSDK', '~> 1.0'


### Initialize

For this step, you will need to set your SMS Sort Code, Shared Service Code and SMS Encryption Key for the Vela Control System. To Setup, Initialize the SDK as shown below:  

1.  Extend the `VelaAPI` class, and override `smsAPIShortCode(bool: isLive)`,  `smsEncryptionKey()`, `merchantSharedCode` functions  to set the SMS Sort Code, Encryption Key, and Shared Service Code respectively.  e.g.  
    ```
    class MyAPI: VelaAPI{
        override func smsAPIShortCode(bool: isLive) -> String{
            return isLive ? "33445" : "12345"
        }
        
        override func smsEncryptionKey() -> String{
            return "enkey0123456789"
        }
        
        override func merchantSharedCode() -> String? {
            return "05" 
        }
    }
    ```

2. In your `AppDelegate`  application func, i.e `func application`, call the `initVela(api: VelaAPI, isLive: Bool)` method with the  extended `VelaAPI` as the api argument. e.g  
    ```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initVela(api: MyAPI(), isLive: false)
    }
    ```

### Usage

To send SMS API Request from a `UIViewController`, you must first extend the `SMSUIViewController` class, and then call the `sendRequest(encryptedMessage: String)` or `sendRequest(message: SMSMessagePipeline)` method. e.g.
    
    class MainUIViewController: SMSUIViewController{
        override func viewDidLoad() {
            payButton.addTagGestureListener{
                let message = ... 
                sendRequest(encryptedText: message)
            }
        }
        
        //called after an SMS request is sent
        open func smsRequestSent(controller: MFMessageComposeViewController, result: MessageComposeResult){
            controller.dismiss(animated: true, completion: nil)
        }
    }

#### Creating a Transaction SMS Request

To create a transaction request, e.g Cash Transfer request, firstly, you have declare `CashTransferSMSAPI` class and then pass the neccessary payload data.

    let data = CashTransferSMSAPI.Data()
    data.accountNo = "1234567890"
    data.amount = 10000
    data.bank = Bank.UBA_BANK
    data.pin = "xxxx"
    data.sourceBankAccountId = "123456"
    data.userId = "12345678"

    let cashTransferSMSApi = CashTransferSMSAPI(data: data)
    sendRequest(message: cashTransferSMSApi)
    
once a request is sent, an SMS response message containing a 6-digits comfirmation code is sent back to the user, the user is required to input the confirmation code on the app, which is then validated to perform a corresponding action.  

> Validating Confirmation code  
    
    let confirmationCode = ...
    
    let validation = cashTransferSMSApi.validateConfirmationCode(confirmationCode: confirmationCode)
    switch(validation){
    case ConfirmationMessageResult.REQUEST_SUCCESSFUL:
        // cash transfer request was successful:  
    case ConfirmationMessageResult.REQUEST_FAILED:
        // cash transfer request failed
    case ConfirmationMessageResult.OTP_REQUIRED:
        // otp is required required for cash transaction
    default:
        //an invalid confirmation code was inputed
    }

Table of Transaction SMS API Classes:  

Class Name | Data Payload Class | Description 
------------ | ------------- | ------------
`AccountCreationSMSAPI` |  `AccountCreationSMSAPI.Data` | User Account Creation
`AccountCreationConfirmationSMSAPI` |  `AccountCreationConfirmationSMSAPI.Data` | Stage 2 of Account Creation, Verifying Account Number and OTP
`AccountLoginSMSAPI` | `AccountLoginSMSAPI.Data` | User Login and Account Authentication.
`UserProfileUpdateSMSAPI` | `UserProfileUpdateSMSAPI.Data` | User Profile Information Update.
`CashTransferSMSAPI` | `CashTransferSMSAPI.Data` | Cash Transfer.
`BillPaymentSMSAPI` | `BillPaymentSMSAPI.Data` | Bill Payment such as Airtime, Data, Electricity, etc.
`NewBankAccountSMSAPI` | `NewBankAccountSMSAPI.Data` | Add a new Transaction Bank Account.
`PinUpdateSMSAPI` | `PinUpdateSMSAPI.Data` | Update Transaction Pin.
`PasswordUpdateSMSAPI` | `PasswordUpdateSMSAPI.Data` | User Password Update.


#### BillProductConstant
Bill Payment payload class `BillPaymentSMSAPI.Data` contains an attribute `billProductId` which identifies the type of bill involved in the transaction e.g, DSTV Bill, Airtime Recharge Bill, etc. 
Below is a list of methods to get a corresponding `billProductId`

- `BillProductConstant.getAirtimeBillInfo(service: AirtimeService)` to get Airtime bills product id.
- `BillProductConstant.getDataBillInfo(service: DataService)` to get data bills product id
- `BillProductConstant.getInternetPlan(service: InternetService)` to get internet bills product id
- `BillProductConstant.getTvBouquets(service: CabletvService)` to get cable tv bills product id
- `BillProductConstant.getElectricityBillInfo(service: ElectricityService)`  to get electricity bills product id


