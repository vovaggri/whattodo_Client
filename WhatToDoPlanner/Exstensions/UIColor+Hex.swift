//
//  UIColor+Hex.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 16.01.2025.
//

import UIKit

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHex = cleanedHex.hasPrefix("#") ? String(cleanedHex.dropFirst()) : cleanedHex
        
        guard cleanedHex.count == 6 || cleanedHex.count == 8 else { return nil }
            
        var hexValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&hexValue)
            
        let hasAlpha = cleanedHex.count == 8
        let extractedAlpha = hasAlpha ? CGFloat((hexValue & 0xFF000000) >> 24) / 255.0 : alpha
        let finalAlpha = hasAlpha ? extractedAlpha : alpha
            
        let red = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x000000FF) / 255.0
            
        self.init(red: red, green: green, blue: blue, alpha: finalAlpha)
     }
}
