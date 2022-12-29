//
//  Bundle+Extension.swift
//  
//
//  Created by Vishweshwaran on 29/12/22.
//

import Foundation

extension Bundle {
    static func getJSONData(fileName: String, bundle: Bundle = Bundle.module) -> Data {
        let jsonURL = bundle.url(forResource: fileName, withExtension: "json")!
        let data = try! Data(contentsOf: jsonURL)
        return data
    }
}
