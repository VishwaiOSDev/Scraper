//
//  WebURL.swift
//  
//
//  Created by Vishweshwaran on 27/12/22.
//

import Foundation
import NetworkKit

enum XRate: String, CaseIterable {
    case ARS, AUD, BHD, BWP, BRL, GBP, BND
    case BGN, CAD, CLP, CNY, COP, HRK, CZK
    case DKK, EUR, HKD, HUF, ISK, INR, IDR
    case IRR, ILS, JPY, KZT, KWD, LVL, LYD
    case LTL, MYR, MUR, MXN, NPR, TWD, NZD
    case NOK, OMR, PKR, PHP, PLN, QAR, RON
    case RUB, SAR, SGD, ZAR, KRW, LKR, SEK
    case CHF, THB, TTD, TRY, AED, USD, VEF
}

extension XRate: NetworkRequestable {
    
    var host: String { "x-rates.com" }
    
    var path: String { "/table" }
    
    var httpMethod: HTTPMethod { return .get }
    
    var queryParameter: [String : AnyHashable]? {
        return ["from": self.rawValue, "amount": 1]
    }
}
