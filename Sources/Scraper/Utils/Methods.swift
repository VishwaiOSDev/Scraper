//
//  Methods.swift
//  
//
//  Created by Vishweshwaran on 29/12/22.
//

import Foundation

@discardableResult
func boolEnvVariable(get key: String) -> Bool {
    guard let variable = ProcessInfo.processInfo.environment[key] else { return false }
    return Bool(variable) ?? false
}
