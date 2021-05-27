//
//  CustomImage.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class CustomImage {
    static func image(color: UIColor) -> UIImage {
        switch color {
        case .customGrayForArray():
            return UIImage(named: "icGrayFolder")!
        case .customBlueForArray():
            return UIImage(named: "icBlueFolder")!
        case .customRedForArray():
            return UIImage(named: "icRedFolder")!
        case .customPurpleForArray():
            return UIImage(named: "icPurpleFolder")!
        case .customGreenForArray():
            return UIImage(named: "icGreenFolder")!
        case .customOrangeForArray():
            return UIImage(named: "icOrangeFolder")!
        default:
            return UIImage(named: "icGrayFolder")!
        }
    }

}
