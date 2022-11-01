//
//  Validator.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import Foundation

final class Validator {
    static func isEmpty(_ value: String?) -> Bool {
        if let value = value {
            return value.isEmpty
        }
        return true
    }
    
}
