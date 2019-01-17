//
//  BillPaymentConstant.swift
//  VelaSDK
//
//  Created by Igbalajobi Elias on 12/11/18.
//  Copyright © 2018 Igbalajobi Elias. All rights reserved.
//

public class BillPaymentConstant{
    public static func getAirtimeBillInfo(service: AirtimeService) -> BillProductData{
        switch service {
        case .MTNVTU:
            return json(filename: "airtimebundle")[0]
        case .AirtelVTU:
            return json(filename: "airtimebundle")[1]
        case .GLOVTU:
            return json(filename: "airtimebundle")[2]
        default:
            return json(filename: "airtimebundle")[3]
        }
    }
    
    public static func getTollBillInfo(service: TollService) -> [BillProductData]{
        switch service {
        default:
            return json(filename: "lccpackage")
        }
    }
    
    public static func getInternetPlan(service: InternetService) -> [BillProductData]{
        switch service {
        case .smileInternet:
            return json(filename: "smileinternetplan")
        case .swiftInternet:
            return json(filename: "swiftinternetplan")
        case .spectranetInternet:
            return json(filename: "spectranetinternetplan")
        case .mtnhynet:
            return json(filename: "mtnhynetplan")
        default:
            return json(filename: "ipnxinternetplan")
        }
    }
    
    public static func getDataBillInfo(service: DataService) -> [DataBillEntry]{
        switch service {
        case .AirtelDATA:
            return json(filename: "airteldatabundle")
        case .MTNDATA:
            return json(filename: "mtndatabundle")
        case .GLODATA:
            return json(filename: "glodatabundle")
        default:
            return json(filename: "9mobiledatabundle")
        }
    }
    
    public static func getTvBouquets(service: CabletvService) -> [BillProductData]{
        switch service {
        case .dstvCableTV:
            return json(filename: "dstvbundle")
        case .gotvCableTV:
            return json(filename: "gotvbundle")
        default:
            return json(filename: "startimesbundle")
        }
    }
    
    public static func getElectricityBillInfo(service: ElectricityService) -> BillProductData{
        switch service {
        case .ikedcPrepaid:
            return json(filename: "ikedcpackage")[1]
        case .ikedcPostpaid:
            return json(filename: "ikedcpackage")[0]
        case .ekoElectricityPrepaid:
            return json(filename: "ekedcpackage")[1]
        default:
            return json(filename: "ekedcpackage")[0]
        }
    }
}

public struct DataBillEntry: Codable {
    var amount: Int!
    var dataCap: String!
    
    var name: String!
    var fee: Int!
    var productId: String!
    var fixedAmount: Bool!
    var maximumAmount: Int!
    var minimumAmount: Int!
}

public enum TollService: Int{
    case lccToll = 3
}

public enum CabletvService: Int{
    case dstvCableTV = 12
    case gotvCableTV = 13
    case starttimesCableTV = 14
    case irokoTV = 15
}

public enum BettingService: Int{
    case bet9ja = 8
    case nairabetBetting = 9
    case sureBet = 10
    case merrybetBetting = 11
}

public enum ElectricityService: Int{
    case ikedcPostpaid = 4
    case ikedcPrepaid = 5
    case ekoElectricityPostpaid = 6
    case ekoElectricityPrepaid = 7
}

public enum AirtimeService: Int{
    case AirtelVTU = 180
    case MTNVTU = 181
    case GLOVTU = 182
    case NineMobileVTU = 183
}

public enum InternetService: Int{
    case smileInternet = 1
    case swiftInternet = 2
    case spectranetInternet = 19
    case ipnxInternet = 20
    case mtnhynet = 21
}

public enum DataService: Int{
    case AirtelDATA = 160
    case MTNDATA = 161
    case GLODATA = 162
    case NineMobileDATA = 163
}

fileprivate func json<T: Codable>(filename: String) -> [T]{
    return try! decodeJSONToObject(filename: filename)
}

fileprivate func decodeJSONToObject<T: Codable>(filename: String) throws -> T{
    let path = Bundle.main.path(forResource: filename, ofType: "json")
    let data = try Data(contentsOf: URL(fileURLWithPath: path!))
    
    return try JSONDecoder().decode(T.self, from: data)
}

public struct BillProductData: Codable {
    var name: String!
    var amount: Int!
    var fee: Int!
    var productId: String!
    var fixedAmount: Bool!
    var maximumAmount: Int
    var minimumAmount: Int
}

public struct Bank{
    public static var ACCESS_BANK = "044"
    public static var ACCESS_MOBILE = "323"
    public static var AFRIBANK = "014"
    public static var ASO_SAVINGS_AND_LOANS = "401"
    public static var CORONATION_MERCHANT_BANK = "559"
    public static var DIAMOND_BANK = "063"
    public static var ECOBANK_MOBILE = "307"
    public static var ECOBANK = "050"
    public static var ENTERPRISE_BANK = "084"
    public static var FIRST_BANK_MOBILE = "309"
    public static var FIDELITY_BANK = "070"
    public static var FIRST_BANK = "011"
    public static var FCMB = "214"
    public static var FSDH_MERCHANT_BANK = "601"
    public static var GTBANK_MOBILE = "315"
    public static var GTBANK = "058"
    public static var HERITAGE_BANK = "030"
    public static var KEYSTONE_BANK = "082"
    public static var PARKWAY_BANK = "311"
    public static var PARRALAX_BANK = "526"
    public static var PAYCOM = "305"
    public static var SKYE_BANK = "076"
    public static var STANBIC_IBTC_BANK = "221"
    public static var STANBIC_MOBILE = "304"
    public static var STANDARD_CHATERED_BANK = "068"
    public static var STERLING_BANK = "232"
    public static var UNION_BANK = "032"
    public static var UBA_BANK = "033"
    public static var UNITY_BANK = "215"
    public static var WEMA_BANK = "035"
    public static var ZENITH_BANK = "057"
    public static var ZENITH_MOBILE = "322"
}
