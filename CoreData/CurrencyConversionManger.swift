//
//  CurrencyConversionManger.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//

import Foundation

struct CurrencyConversionManager {
    
    private let _CurrencyConversionDataRepository = CurrrencyConversionDataRepository()
    func createCurrencyConversionModel(currencyConversion: ConversionTableViewCellModel){
        _CurrencyConversionDataRepository.create(currencyConversion: currencyConversion)
    }
    
    func checkIfExist(value: String) -> Bool {
        return _CurrencyConversionDataRepository.getByKey(key: value)
    }
    
    func fetchCurrencyConversionModel() -> [ConversionTableViewCellModel]?{
        return _CurrencyConversionDataRepository.getAll()
    }
    
    func updateCurrencyConversionModel(currencyConversion: ConversionTableViewCellModel) -> Bool {
        return _CurrencyConversionDataRepository.update(currencyConversion: currencyConversion)
    }
    
    func deleteCurrencyModel(currencyConversion: ConversionTableViewCellModel) -> Bool {
        return _CurrencyConversionDataRepository.delete(currencyConversion: currencyConversion)
    }
    
}
