//
//  CurrencyViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Keshav Kishore on 12/02/23.
//

import XCTest
@testable import PayPay_UIKit

final class CurrencyViewModelTests: XCTestCase {
    private var service = MockCurrencyDataService()
    private var currency: Currency?
    
    private var viewModel: CurrencyConverionControllerViewModel {
        CurrencyConverionControllerViewModel(dataService: service)
    }
    
    func testCurrencyIsParsedCorrectly() {
        viewModel.populateDropDownView { _ in }
        XCTAssertEqual(currency?.count, 1)
    }
    
    func testCurrencyKeyIsParsedCorrectly() {
        viewModel.populateDropDownView { _ in }
        XCTAssertEqual(currency?["IND"], "Indian Rupees")
    }
    
    func testCurrencyValueIsParsedCorrectly() {
        viewModel.populateDropDownView { _ in }
        XCTAssertEqual(currency?["IND"], "Indian Rupees")
    }
}

