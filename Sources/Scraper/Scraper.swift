//
//  Scraper.swift
//  
//
//  Created by Vishweshwaran on 26/12/22.
//

import Foundation
import SwiftSoup
import NetworkKit

@main
class Scraper {
    
    var currencyRate: [String: Any] = [:]
    
    init() {
        XRate.allCases.forEach { currencyRate[$0.rawValue] = [:] }
    }
    
    func isWebLive(webURL: URL) -> Bool {
        print(currencyRate)
        return false
    }
    
    func convertToHTML(from url: URL) {
        do {
            let content = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(content)
            let table = try doc.select("tbody")
            let rows = try table.select("tr")
            var currencyRate = try rows.map { element in
                let cells = try element.select("td")
                let currency = try cells.get(0).text()
                let rate = try cells.get(2).text()
                return (currency: currency, rate: rate)
            }
            print(currencyRate.first)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Scraper {
    
    static func main() {
        let scraper = Scraper()
        let inrURL = try! XRate.INR.url
        scraper.isWebLive(webURL: inrURL)
    }
}
