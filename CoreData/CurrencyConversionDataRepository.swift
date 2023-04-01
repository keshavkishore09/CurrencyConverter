//
//  CurrencyConversionDataRepository.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//

import Foundation
import CoreData
protocol CurrencyConversionRepository {
    func create(currencyConversion: ConversionTableViewCellModel)
    func getAll() -> [ConversionTableViewCellModel]?
    func getByKey(key: String) -> Bool
    func update(currencyConversion: ConversionTableViewCellModel) -> Bool
    func delete(currencyConversion: ConversionTableViewCellModel) -> Bool
}

struct CurrrencyConversionDataRepository: CurrencyConversionRepository {
    
    func create(currencyConversion: ConversionTableViewCellModel) {
        
        let cdCurrencyConversion = CDCurrencyConversionModel(context: PersistentStorage.shared.context)
        cdCurrencyConversion.currencyName = currencyConversion.currencyName
        cdCurrencyConversion.currencyFullName = currencyConversion.currencyFullName
        cdCurrencyConversion.rate = currencyConversion.rate
        PersistentStorage.shared.saveContext()
    }
    
    func getByKey(key: String) -> Bool {
        let cdCurrencyConversion = getCDCurrency(bycurrName: key)
        guard cdCurrencyConversion != nil else {return false}
        return true
    }
    
    func getAll() -> [ConversionTableViewCellModel]? {
        let result =  PersistentStorage.shared.fetchManagedObject(managedObject: CDCurrencyConversionModel.self)
        var currenciesConversion: [ConversionTableViewCellModel] = []
        result?.forEach({
            currenciesConversion.append($0.convertToCurrencyConversionModel())
        })
        
        return currenciesConversion
        
    }
    
    func update(currencyConversion: ConversionTableViewCellModel) -> Bool {
        let cdCurrencyConversion = getCDCurrency(bycurrName: currencyConversion.currencyName)
        guard cdCurrencyConversion != nil else {return false}
        cdCurrencyConversion?.currencyName = currencyConversion.currencyName
        cdCurrencyConversion?.currencyFullName = currencyConversion.currencyFullName
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func delete(currencyConversion: ConversionTableViewCellModel) -> Bool {
        let cdCurrencyConversion = getCDCurrency(bycurrName: currencyConversion.currencyName)
        guard let cdCurrencyConversion = cdCurrencyConversion else {return false}
        PersistentStorage.shared.context.delete(cdCurrencyConversion)
        return true
    }
    
    
    private func getCDCurrency(bycurrName currencyName: String) -> CDCurrencyConversionModel? {
        
        let fetchRequest = NSFetchRequest<CDCurrencyConversionModel>(entityName: "CDCurrencyConversionModel")
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
