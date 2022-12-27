//
//  Collection+Extension.swift
//  
//
//  Created by Vishweshwaran on 27/12/22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
