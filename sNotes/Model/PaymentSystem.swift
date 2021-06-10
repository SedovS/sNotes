//
//  PaymentSystem.swift
//  sNotes
//
//  Created by Sergey Sedov on 07.06.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

class PaymentSystem {
    
    func namePS(firstNumberCard: String) -> String? {
        guard let card = Int(firstNumberCard) else {
            return nil
        }
        switch card {
            
        case 2:
            return "Mir"
        case 3:
            return nil  // xz JCB International ? Maestro ? American Express
        case 4:
            return  "Visa"
        case 5:
            return "MasterCard" //? Maestro ?
        case 6:
            return "Maestro"//Maestro - 3, 5 или 6
        default:
            return nil
        }
    }
    
    
}
