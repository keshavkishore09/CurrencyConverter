//
//  CurrencyModel+TestData.swift
//  CurrencyConverterTests
//
//  Created by Keshav Kishore on 12/02/23.
//

import XCTest
@testable import PayPay_UIKit

extension CurrencyModel {
    static func testData() -> CurrencyModel {
        return CurrencyModel.init(currencyName: "INR", currencyFullName: "Indian Rupees")
    }
}
