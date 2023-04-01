//
//  CurrencyConverionControllerViewModel.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//

import Foundation


enum DatabaseOperation {
    case updateDatabase
    case createDatabase
}

class CurrencyConverionControllerViewModel {
    
    private(set) var currencyModels = [CurrencyModel]()
    private(set) var selectedCurrency: CurrencyModel!
    private(set) var errorString: String? = nil
    private(set) var convertedCurrenyModel: CurrencyConversionModel!
    private(set) var currencyConversionTableViewCellModel = [ConversionTableViewCellModel]()
    private let dataService: DataServiceable
    
    init(dataService: DataServiceable = CurrencyDataService()) {
            self.dataService = dataService
        }
    
    func populateDropDownView(completion: @escaping(Bool) -> Void) {
        let currencyManager = CurrencyManager()
        dataService.performNetworkTask(urlFor: .Currencies, base: nil, resultType: Currency.self)  {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case .success(let currency):
                for key in currency.keys {
                    let model = CurrencyModel(currencyName: key, currencyFullName: currency[key]!)
                    self.currencyModels.append(model)
                    if !(currencyManager.checkIfExist(currency: model)) {
                        currencyManager.createCurrencyModel(currency: model)
                    }
                }
                self.currencyModels = self.currencyModels.sorted { $0.currencyFullName < $1.currencyFullName}
                completion(true)
                break
            case .failure(.failedToGetDataAsNoNetworkAvailable):
                self.errorString = "Network is not available"
                completion(false)
                break
            case .failure(.failedToGetData):
                self.errorString = "Failed to get the data"
                completion(false)
                break
            case .failure(.failedToParseData):
                self.errorString = "Failed to parse the data"
                completion(false)
                break
            }
        }
        
    }
    
    
    func populateTableViewWithConvertedCurencies(selectedCurrency: CurrencyModel, completion: @escaping(Bool) -> Void) {
        self.selectedCurrency = selectedCurrency
        if checkIfValueExistInDatabase() {
            if (shouldFetchFromAPI()) {
                debugPrint("Getting data from API as the it is stale data in databse")
                getDataFromRemote(updateDatabase: .updateDatabase) { success in
                    completion(success)
                }
            } else {
                debugPrint("Getting data from database as the it is fresh data in databse")
                getDataFromDatabase { success in
                    completion(success)
                }
            }
        } else {debugPrint("Getting data from remote as there is no data in databse")
            getDataFromRemote(updateDatabase: .createDatabase) { success in
                completion(success)
            }
        }
    }
}

// MARK: - Private Functions
extension CurrencyConverionControllerViewModel {
    
    private func checkIfValueExistInDatabase() -> Bool {
        let currencyConversionManager = CurrencyConversionManager()
        if  !(currencyConversionTableViewCellModel.isEmpty) {
            debugPrint("Value Exist in local memory")
            return true
        }
        else if (currencyConversionManager.checkIfExist(value: selectedCurrency.currencyName)){
            debugPrint("Value Exist in databse")
            return true
        } else {
            debugPrint("Value doesn't Exist in databse nor in local memory")
            return false
        }
    }
    
    private func saveToDatabase(currencyConversion: ConversionTableViewCellModel, updateDataBase: DatabaseOperation) {
        let currencyConversionManager = CurrencyConversionManager()
        switch updateDataBase {
        case .updateDatabase:
            if !(currencyConversionManager.checkIfExist(value: currencyConversion.currencyName)) {
                _ = currencyConversionManager.updateCurrencyConversionModel(currencyConversion: currencyConversion)
            }
        case .createDatabase:
            if !(currencyConversionManager.checkIfExist(value: currencyConversion.currencyName)) {
                currencyConversionManager.createCurrencyConversionModel(currencyConversion: currencyConversion)
            }
        }
    }
    
    private func getDataFromDatabase(completion: (Bool) -> Void) {
        self.prepareTheCellModelWhenfetchedOffline()
        completion(true)
    }
    
    
    private func shouldFetchFromAPI() -> Bool {
        if let savedTimeStamp = UserDefaults.standard.object(forKey: "timeToFetch") as? Date {
            let currentDate = Date()
            let thirtyMinutes: TimeInterval = 1800
            let diff = currentDate.timeIntervalSince(savedTimeStamp)
            return diff >= thirtyMinutes
        }
        
        return true
    }
    
    private func saveTimeStamp(timeStamp: Int) {
        UserDefaults.standard.set(Date(), forKey: "timeToFetch")
    }
    
    
    private func prepareTheCellModelWhenfetchedOnline(updateDatabase: DatabaseOperation, currencies: CurrencyConversionModel) {
        for (key, value) in currencies.rates {
            let model = ConversionTableViewCellModel(currencyName: key, currencyFullName: currencyModels.filter({$0.currencyName == key}).first?.currencyFullName ?? "", rate: value)
            currencyConversionTableViewCellModel.append(model)
            saveToDatabase(currencyConversion: model, updateDataBase: updateDatabase)
            
        }
        
        currencyConversionTableViewCellModel = currencyConversionTableViewCellModel.sorted{$0.currencyFullName < $1.currencyFullName}
    }
    
    private func prepareTheCellModelWhenfetchedOffline() {
        if !(currencyConversionTableViewCellModel.isEmpty) {return}
        let currencyConversionManager = CurrencyConversionManager()
        guard let results = currencyConversionManager.fetchCurrencyConversionModel() else  {return}
        
        results.forEach { model in
            currencyConversionTableViewCellModel.append(ConversionTableViewCellModel(currencyName: model.currencyName, currencyFullName: model.currencyFullName, rate: model.rate))
        }
        currencyConversionTableViewCellModel = currencyConversionTableViewCellModel.sorted{$0.currencyFullName < $1.currencyFullName}
    }
    
    private func getDataFromRemote(updateDatabase: DatabaseOperation,completion: @escaping(Bool) -> Void) {
        guard selectedCurrency.currencyName == "USD" else {
            self.errorString = "Failed to get the data"
            completion(false)
            return}
        dataService.performNetworkTask(urlFor: .ConversionData,
                                       base: selectedCurrency.currencyName,
                                       resultType: CurrencyConversionModel.self) {[weak self] result in
            switch result {
            case .success(let convertedCurrencies):
                self?.prepareTheCellModelWhenfetchedOnline(updateDatabase: updateDatabase, currencies: convertedCurrencies)
                self?.saveTimeStamp(timeStamp: convertedCurrencies.timestamp)
                completion(true)
                break
            case .failure(.failedToGetDataAsNoNetworkAvailable):
                self?.errorString = "Network is not available"
                completion(false)
                break
            case .failure(.failedToGetData):
                self?.errorString = "Failed to get the data"
                completion(false)
                break
            case .failure(.failedToParseData):
                self?.errorString = "Failed to parse the data"
                completion(false)
                break
            }
        }
    }
}


