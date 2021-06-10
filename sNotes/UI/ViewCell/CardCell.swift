//
//  CardCell.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {

    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        numberLabel.text = ""
        commentLabel.text = ""
        cardView.shadow()
        // Initialization code
    }

    
    func initCell(card: CardDM) {
        nameLabel.text = card.nameBank ?? " "
        numberLabel.text = "**** **** **** " + card.last4Number
        commentLabel.text = card.comment
        cardView.backgroundColor = .black
        icon.image = UIImage(named: card.paymentSystem ?? "")
    }
    
}
