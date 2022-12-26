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
    
    func convertToHTML(from url: URL) {
        let content = try! String(contentsOf: url)
        do {
            let doc: Document = try SwiftSoup.parse(content)
            let table = try doc.select("tbody")
            let rows = try table.select("tr")
            try rows.forEach { element in
                let row = try element.select("td")
                print(try row.text())
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Scraper {
    
    static func main() {
        let webURL = URL(string: "https://www.x-rates.com/table/?from=INR&amount=1")!
        Scraper().convertToHTML(from: webURL)
    }
}
