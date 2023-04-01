//
//  APICaller.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 08/02/23.
//

import Foundation
import Reachability

typealias Currency = [String: String]

enum APIError: Error {
    case failedToGetDataAsNoNetworkAvailable
    case failedToGetData
    case failedToParseData
}

struct Constants {
    static let apiKey = "91a5f3aca051444dbab0bd18b5be7a0c"
    static let curency_root_url = "https://openexchangerates.org/api/currencies.json?app_id=\(apiKey)"
    static let currencyconvert_root_url = "https://openexchangerates.org/api/latest.json?app_id=\(apiKey)"
    static let baseCurrency = "&base="
}

enum URlType {
    case Currencies
    case ConversionData
}

enum HTTPMethod: String {
    case GET
    case POST
}


protocol DataServiceable {
    func performNetworkTask<T: Decodable>(urlFor: URlType,
                                          base: String?,
                                          resultType: T.Type,
                                          completion: @escaping(Result<T, APIError>) -> Void)
}

struct DataService: DataServiceable {
    let reachability = try! Reachability()
    
    func performNetworkTask<T: Decodable>(urlFor: URlType,
                                          base: String?,
                                          resultType: T.Type,
                                          completion: @escaping(Result<T, APIError>) -> Void) {
        guard reachability.connection != .unavailable else {
            completion(.failure(.failedToGetDataAsNoNetworkAvailable))
            return
        }
        guard let request = createRequest(type: .GET, urlType: urlFor, base: base) else {return}
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.failedToGetData))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let jsonDict = json as? [String: Any] {
                    if (jsonDict["error"] as? Int == 1 && jsonDict["status"] as? Int == 403) {
                        completion(.failure(.failedToGetData))
                    }
                }
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.failedToParseData))
            }
        }.resume()
        
    }
        
    

    private func createRequest(type: HTTPMethod, urlType: URlType, base: String?) -> URLRequest? {
        var url: URL!
        switch urlType {
        case .Currencies:
            url = URL(string: Constants.curency_root_url)
        case .ConversionData:
            guard let base  = base else {return nil}
            url = URL(string: "\(Constants.currencyconvert_root_url)\(Constants.baseCurrency)\(base)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        return request
    }    
}











