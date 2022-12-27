//
//  Scraper.swift
//  
//
//  Created by Vishweshwaran on 26/12/22.
//

import Foundation
import SwiftSoup

@main
class Scraper {
    
    init() {}
    
    func isWebLive(webURL: URL) -> Bool {
        return false
    }
    
    func convertToHTML(from url: URL) {
        let content = try! String(contentsOf: url)
        do {
            let doc: Document = try SwiftSoup.parse(content)
            let table = try doc.select("tbody")
            let rows = try table.select("tr")
            try rows.forEach { element in
                let row = try element.select("td").array()
                guard let country = row[safe: 0], let price = row[safe: 2] else { return }
                print("\(try country.text()): \(try price.text())")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Scraper {
    
    static func main() {
        let _ = Scraper()
    }
}
