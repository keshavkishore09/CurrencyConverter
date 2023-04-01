//
//  CurrencyDataServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Keshav Kishore on 12/02/23.
//

import XCTest
@testable import PayPay_UIKit

final class CurrencyDataServiceTests: XCTestCase {
    private var service = MockCurrencyDataService()

    private var viewModel: CurrencyConverionControllerViewModel {
        CurrencyConverionControllerViewModel(dataService: service)
    }

    func testThatApiFetchIsCalledAfterViewDidLoad() {
        viewModel.populateDropDownView { _ in }
        viewModel.populateTableViewWithConvertedCurencies(
            selectedCurrency: CurrencyModel.testData()
        ) { _ in }
        XCTAssertTrue(service.isFetchCurrencyCalled)
        XCTAssertTrue(service.isFetchCurrencyCalled)
    }
}
