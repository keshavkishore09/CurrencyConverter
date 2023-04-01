//
//  MockCurrencyDataService.swift
//  CurrencyConverterTests
//
//  Created by Keshav Kishore on 12/02/23.
//

import XCTest
final class MockCurrencyDataService: DataServiceable {
    var isFetchCurrencyCalled = false
    var isFetchCurrencyModelCalled = false

    let currency: Currency

    init(with currency: Currency = Currency.testData()) {
        self.currency = currency
    }

    func performNetworkTask<T>(urlFor: PayPay_UIKit.URlType,
                               base: String?,
                               resultType: T.Type,
                               completion: @escaping (Result<T, PayPay_UIKit.APIError>) -> Void) where T : Decodable {
        isFetchCurrencyCalled = true
        isFetchCurrencyModelCalled = true
        completion(currency as! T as! Result<T, APIError>)
    }
}
