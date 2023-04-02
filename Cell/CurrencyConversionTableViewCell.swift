//
//  CurrencyConversionTableViewCell.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 11/02/23.
//

import UIKit



class CurrencyConversionTableViewCell: UITableViewCell {
    
    private var currencyShortName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xA0A0A0)
        return label
    }()
    
    private var currencyValue: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x5D5D5D)
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    
    private var perUnitValue: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xA0A0A0)
        return label
    }()
    
    private var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF0F0F0)
        return view
    }()
    
    
    var userSelectedCurrencyPriceToUSD: Double!
    var selectedCurrency: CurrencyModel!
    var amountToConvert: Double!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(symbolLabel)
        contentView.addSubview(perUnitValue)
        contentView.addSubview(dividerView)
        contentView.addSubview(currencyShortName)
        contentView.addSubview(currencyValue)
        
        
        symbolLabel.anchor(top: topAnchor, left: leftAnchor, bottom: currencyShortName.topAnchor, right: dividerView.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 50, height: 0, enableInsets: true)
        
        
        currencyShortName.anchor(top: symbolLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: dividerView.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0, enableInsets: true)
        
        
        dividerView.anchor(top: topAnchor, left: symbolLabel.rightAnchor, bottom: bottomAnchor, right: currencyValue.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 1, height: 0, enableInsets: true)
        
        
        
        currencyValue.anchor(top: symbolLabel.topAnchor, left: dividerView.rightAnchor, bottom: perUnitValue.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        
        
        perUnitValue.anchor(top: currencyShortName.topAnchor, left: currencyValue.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func configure(with model: ConversionTableViewCellModel) {
        currencyShortName.text = model.currencyName
        let valuePerUnit = model.rate * (1/userSelectedCurrencyPriceToUSD)
        let roundOffValue = Double(round(1000 * valuePerUnit) / 1000)
        currencyValue.text = "\(roundOffValue * amountToConvert)"
        symbolLabel.text = getSymbol(model: model) ?? model.currencyName
        // perUnitValue.text = "1 \(selectedCurrency.currencyName) = \(roundOffValue) \(model.currencyFullName)"
    }
    
    
    func getSymbol(model:  ConversionTableViewCellModel) -> String? {
        let locale = NSLocale(localeIdentifier: model.currencyName)
        if locale.displayName(forKey: .currencySymbol, value: model.currencyName) == model.currencyName {
            let newLocale = NSLocale(localeIdentifier: model.currencyName.dropLast() + "_en")
            return newLocale.displayName(forKey: .currencySymbol, value: model.currencyName)
        }
        return locale.displayName(forKey: .currencySymbol, value: model.currencyName)
    }
}
