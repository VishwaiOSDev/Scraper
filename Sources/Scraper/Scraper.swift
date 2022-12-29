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
            try await XRate.allCases.asyncForEach { currencyCode in
                try await isReachableStartScraping(for: currencyCode)
            }
            toJSON(from: currencyRate)
        } catch {
            Log.error(error.localizedDescription)
        }
    }
    
    func isReachableStartScraping(for website: XRate) async throws {
        guard await NetworkKit.shared.ping(website) else { return }
        let document = try toHTML(of: try website.url)
        try scrap(website: document, for: website.rawValue)
    }
    
    func scrap(website: Document, for currency: String) throws {
        try extractData(from: website, for: currency)
    }
    
    func extractData(from document: Document, for currencyCode: String) throws {
        do {
            let table = try document.select("tbody")
            let rows = try table.select("tr")
            let currentCurrencyRate = try rows.map { element in
                let cells = try element.select("td")
                let currency = try cells.get(0).text()
                let rate = try cells.get(2).text()
                return [currency: rate]
            }
            currencyRate[currencyCode] = currentCurrencyRate
        } catch {
            throw error
        }
    }
    
    func toJSON(from dict: NestedDictionary) {
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
