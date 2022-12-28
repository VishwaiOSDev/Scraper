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
    
    var currencyRate: [String: [[String: String]]] = [:]
    
    init() {
        XRate.allCases.forEach { currencyRate[$0.rawValue] = [[:]] }
        Task {
            await runScraper()
        }
    }
    
    func runScraper() async {
        do {
            guard await isReachable(XRate.INR) else { return }
            let inrURL = try XRate.INR.url
            let document = try toHTML(of: inrURL)
            try extractData(from: document)
        } catch {
            print("Error: \(error.localizedDescription)")
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
    static func main() {
        let _ = Scraper()
    }
}
