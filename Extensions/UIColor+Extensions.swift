//
//  UIColor+Extensions.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 12/02/23.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex >> 16) & 0xff)/255, green:  CGFloat((hex >> 08) & 0xff)/255, blue:  CGFloat((hex >> 00) & 0xff)/255, alpha: alpha)
    }
}
