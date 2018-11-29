//
//  String+.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
extension Int {
    func toCurrency() -> String {
        return NSNumber(value: self).toCurrency()
    }
}

extension Int64 {
    func toCurrency() -> String {
        return NSNumber(value: self).toCurrency()
    }
}

extension NSNumber {
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        return (formatter.string(from: self) ?? "")
    }
}
