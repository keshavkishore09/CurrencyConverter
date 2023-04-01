//
//  CurrencyDataRepository.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//

import Foundation
import CoreData

protocol CurrencyRepository {
    func create(currency: CurrencyModel)
    func getAll() -> [CurrencyModel]?
    func getByKey(key: CurrencyModel) -> Bool
    func update(currency: CurrencyModel) -> Bool
    func delete(currency: CurrencyModel) -> Bool
}

struct CurrrencyDataRepository: CurrencyRepository {
    func create(currency: CurrencyModel) {
        let cdCurrency = CDCurrency(context: PersistentStorage.shared.context)
        cdCurrency.currencyName = currency.currencyName
        cdCurrency.currencyFullName = currency.currencyFullName
        PersistentStorage.shared.saveContext()
    }
    
    func getByKey(key: CurrencyModel) -> Bool {
        let cdCurrency = getCDCurrency(bycurrName: key.currencyName)
        guard cdCurrency != nil else {return false}
        return true
    }
    
    func getAll() -> [CurrencyModel]? {
        let result =  PersistentStorage.shared.fetchManagedObject(managedObject: CDCurrency.self)
        var currencies: [CurrencyModel] = []
        result?.forEach({
            currencies.append($0.convertToCurrencyModel())
        })
        
        return currencies
        
    }
    
    func update(currency: CurrencyModel) -> Bool {
        let cdCurrency = getCDCurrency(bycurrName: currency.currencyName)
        guard cdCurrency != nil else {return false}
        cdCurrency?.currencyName = currency.currencyName
        cdCurrency?.currencyFullName = currency.currencyFullName
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func delete(currency: CurrencyModel) -> Bool {
        let cdCurrency = getCDCurrency(bycurrName: currency.currencyName)
        guard let cdCurrency = cdCurrency else {return false}
        PersistentStorage.shared.context.delete(cdCurrency)
        return true
    }
    
    
    private func getCDCurrency(bycurrName currencyName: String) -> CDCurrency? {
        
        let fetchRequest = NSFetchRequest<CDCurrency>(entityName: "CDCurrency")
        let predicate = NSPredicate(format: "currencyName==%@", currencyName as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else {return nil}
            return result
        } catch (let error) {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}
