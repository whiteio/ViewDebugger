//
//  JSONRepresentable.swift
//  
//
//  Created by Christopher White on 21/11/2022.
//

import Foundation

internal protocol JSONRepresentable {
    var stringValue: String? { get }
}

extension JSONRepresentable {
    var stringValue: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Array: JSONRepresentable where Element: JSONRepresentable { }
extension JSON: JSONRepresentable { }
