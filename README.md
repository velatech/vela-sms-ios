#  VelaSMS iOS SDK


## Getting Started

Follow the instructions below to get started with `VelaOffline` iOS SDK  


### Initialize

For this step, you will need to set your SMS Sort Code, Shared Service Code and SMS Encryption Key for the Vela Control System. To Setup, Initialize the SDK as shown below:  

1.  Extend the `VelaAPI` class, and override `smsAPIShortCode(bool: isLive)`,  `smsEncryptionKey()`, `merchantSharedCode` functions  to set the SMS Sort Code, Encryption Key, and Shared Service Code respectively.  e.g.  
    ```
    class MyAPI: VelaAPI{
        override func smsAPIShortCode(bool: isLive) -> String{
            return isLive ? "33445" : "12345"
        }
        
        override func smsEncryptionKey() -> String{
            return "enkey12221931933"
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
    ```
    class MainUIViewController: SMSUIViewController{
        override func viewDidLoad() {
            payButton.addTagGestureListener{
                sendRequest(encryptedText: VELA 05:0:CnHFb8c3Sc5YkA5:eIZEWpcfD7+Tesbevu2JW0g9PxaMqf+dnt7biMY6E/TMm1ERxpyqQ0qLTQCnS7h9W6ZP6yocZf4ZaZEGVFbURlePMyoHhKS334tPQ9m+uK4503599627370495g=)
            }
        }
        
        //called after an SMS request is sent
        open func smsRequestSent(controller: MFMessageComposeViewController, result: MessageComposeResult){
            controller.dismiss(animated: true, completion: nil)
        }
    }
    ```
    
    
