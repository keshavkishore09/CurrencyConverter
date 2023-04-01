//
//  CDCurrencyConversionModel+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//
//

import Foundation
import CoreData


extension CDCurrencyConversionModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCurrencyConversionModel> {
        return NSFetchRequest<CDCurrencyConversionModel>(entityName: "CDCurrencyConversionModel")
    }

    @NSManaged public var currencyFullName: String?
    @NSManaged public var currencyName: String?
    @NSManaged public var rate: Double

}

extension CDCurrencyConversionModel : Identifiable {
    func convertToCurrencyConversionModel() -> ConversionTableViewCellModel {
        return ConversionTableViewCellModel(currencyName: self.currencyName ?? "", currencyFullName: self.currencyFullName ?? "", rate: self.rate)
    }
}
