//
//  UIColor.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        
        if scanner.scanHexInt32(&color) {
            self.init(hex: color, useAlpha: hexString.count > 7)
        } else {
            self.init(hex: 0x000000)
        }
    }

    public convenience init(hex: UInt32, useAlpha alphaChannel: Bool = false) {
        let mask = UInt32(0xFF)
        
        let r = hex >> (alphaChannel ? 24 : 16) & mask
        let g = hex >> (alphaChannel ? 16 : 8) & mask
        let b = hex >> (alphaChannel ? 8 : 0) & mask
        let a = alphaChannel ? hex & mask : 255
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        let alpha = CGFloat(a) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
