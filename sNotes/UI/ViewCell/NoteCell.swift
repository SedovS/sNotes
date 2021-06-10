//
//  NoteCell.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class NoteCell: UICollectionViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(title: String, text: String) {
        self.title.text = title
        self.text.text = text
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(_ sender: UITapGestureRecognizer? = nil) {
        print("longpressed")
    }
    
}
