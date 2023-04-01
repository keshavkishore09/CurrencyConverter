//
//  Currency+TestData.swift
//  CurrencyConverterTests
//
//  Created by Keshav Kishore on 12/02/23.
//

import XCTest
@testable import PayPay_UIKit

extension Currency {
    init(with data: [String: String]) {
        self = data
    }
}

extension Currency {
    static func testData() -> Currency {
        return Currency(with: ["INR": "Indian Rupees"])
    }
}
