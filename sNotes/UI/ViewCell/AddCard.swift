//
//  AddCard.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class AddCard: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
        // Initialization code
    }
    
    func initCellCard() {
        icon.image = UIImage(named: "icAddCardBlue")!
        name.text = "Добавить карту"
    }
    
    func initCellPassword() {
        icon.image = UIImage(named: "icAddPasswordBlue")
        name.text = "Добавить пароль"
    }

    

}
