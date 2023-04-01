//
//  CDCurrency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//
//

import Foundation
import CoreData


extension CDCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCurrency> {
        return NSFetchRequest<CDCurrency>(entityName: "CDCurrency")
    }

    @NSManaged public var currencyName: String?
    @NSManaged public var currencyFullName: String?

}

extension CDCurrency : Identifiable {
    func convertToCurrencyModel() -> CurrencyModel {
        return CurrencyModel(currencyName: self.currencyName ?? "", currencyFullName: self.currencyFullName ?? "")
    }
}
