//
//  APIManager.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 10/02/23.
//

import Foundation


struct CurrencyDataService: DataServiceable {
    private let dataService: DataService

    init(dataService: DataService = DataService()) {
        self.dataService = dataService
    }

    func performNetworkTask<T>(urlFor: URlType,
                               base: String?,
                               resultType: T.Type,
                               completion: @escaping(Result<T, APIError>) -> Void) where T: Decodable {
        dataService.performNetworkTask(urlFor: urlFor,
                                       base: base,
                                       resultType: T.self) { (model) in
            completion(model)
        }
    }
}
