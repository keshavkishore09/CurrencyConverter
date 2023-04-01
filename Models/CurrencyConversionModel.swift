//
//  CurrencyConversionModel.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 10/02/23.
//

import Foundation

struct CurrencyConversionModel: Codable {
    let timestamp: Int
    let rates: [String : Double]
}
