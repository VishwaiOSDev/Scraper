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
        } catch {
            Log.error(error.localizedDescription)
        }
    }
    
    func loadJSON() {
        let jsonData = Bundle.getJSONData(fileName: "currency_data")
        let currencyData = try! JSONDecoder().decode(NestedDictionary.self, from: jsonData)
        saveToCSV(currencyData[XRate.INR.rawValue]!, fileName: "\(XRate.INR.rawValue).csv")
    }
    
    func convertToCSV(_ currencyList: [[String : String]]) -> String {
        var csv = "currency,rate \n"
        currencyList.forEach { dict in
            dict.forEach { (key, value) in
                csv += "\(key),\(value) \n"
            }
        }
        return csv
    }
    
    func saveToCSV(_ dict: [[String: String]], fileName: String) {
        let csvFile = convertToCSV(dict)
        Log.debug(FileManager.default.currentDirectoryPath)
//        let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(fileName)
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
        let ENV_IS_DEV_MODE: Bool = boolEnvVariable(get: "IS_DEV_MODE")
        ENV_IS_DEV_MODE ? scraper.loadJSON() : await scraper.runScraper()
    }
}
