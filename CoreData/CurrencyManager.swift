//
//  CurrencyManager.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//

import Foundation


struct CurrencyManager {
    
    private let _CurrencyDataRepository = CurrrencyDataRepository()
    func createCurrencyModel(currency: CurrencyModel){
        _CurrencyDataRepository.create(currency: currency)
    }
    
    func fetchCurrencyModel() -> [CurrencyModel]?{
        return _CurrencyDataRepository.getAll()
    }
    
    func checkIfExist(currency: CurrencyModel) -> Bool {
        return _CurrencyDataRepository.getByKey(key: currency)
    }
    
    
    func updateCurrencyModel(currency: CurrencyModel) -> Bool {
        return _CurrencyDataRepository.update(currency: currency)
    }
    
    func deleteCurrencyModel(currency: CurrencyModel) -> Bool {
        return _CurrencyDataRepository.delete(currency: currency)
    }
    
}
