//
//  CustomColor.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    static func customSectionTitle() -> UIColor {
        return UIColor(hexString: "#A6A6A6")
    }
    
    static func customBlueForTableView() -> UIColor {
        return UIColor(hexString: "#1839E4")
    }
    
    static func customBlueForPassCode() -> UIColor {
        return UIColor(hexString: "#1839E4")
    }
    
    static func customBlueForProfile() -> UIColor {
        return .customBlueForPassCode()
    }
    
    static func customGrayForProfile() -> UIColor {
        return UIColor(hexString: "E2E2E2")
    }
    
    //MARK:- Custom color for Array
    static func customGrayForArray() -> UIColor  {
        return UIColor(hexString: "#828282")
    }
    static func customBlueForArray() -> UIColor {
        return UIColor(hexString: "#3F91D7")
    }
    static func customRedForArray() -> UIColor {
        return UIColor(hexString: "#DA4834")
    }
    static func customPurpleForArray() -> UIColor {
        return UIColor(hexString: "#9B51E0")
    }
    static func customGreenForArray() -> UIColor {
        return UIColor(hexString: "#27AE60")
    }
    static func customOrangeForArray() -> UIColor {
        return UIColor(hexString: "#F2994A")
    }


}
