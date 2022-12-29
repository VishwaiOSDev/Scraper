//
//  Scraper.swift
//  
//
//  Created by Vishweshwaran on 26/12/22.
//

import Foundation
import SwiftSoup
import LogKit
import NetworkKit

typealias NestedDictionary = [String: [[String: String]]]

@main
class Scraper {
    
    var currencyRate: NestedDictionary = [:]

    init() {
        XRate.allCases.forEach { currencyRate[$0.rawValue] = [[:]] }
    }
    
    func runScraper() async {
        do {
            await XRate.allCases.asyncForEach { currencyCode in
                guard await isReachable(currencyCode) else { return }
            }
            //            for currencyCode in XRate.allCases {
            //                Log.verbose(currencyCode)
            //                guard await isReachable(currencyCode) else { return }
            //                let document = try toHTML(of: try currencyCode.url)
            //                try extractData(from: document)
            //            }
        } catch {
            Log.error(error.localizedDescription)
        }
    }
    
    func isReachable(_ webiste: NetworkRequestable) async -> Bool {
        return await NetworkKit.shared.ping(webiste)
    }
    
    func extractData(from document: Document) throws {
        do {
            let table = try document.select("tbody")
            let rows = try table.select("tr")
            let currentCurrencyRate = try rows.map { element in
                let cells = try element.select("td")
                let currency = try cells.get(0).text()
                let rate = try cells.get(2).text()
                return [currency: rate]
            }
            currencyRate[XRate.INR.rawValue] = currentCurrencyRate
            toJSON(from: currencyRate)
        } catch {
            throw error
        }
    }
    
    func toJSON(from dict: [String: [[String: String]]]) {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        }
    }
    
    func toHTML(of url: URL) throws -> Document {
        do {
            let content = try String(contentsOf: url)
            return try SwiftSoup.parse(content)
        } catch {
            throw error
        }
    }
}

extension Scraper {
    
    static func main() async {
        let scraper = Scraper()
        await scraper.runScraper()
    }
}
