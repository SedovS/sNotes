//
//  TabBarView.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol TabBarViewDelegate: class {
    func pressAddButton()
}

class TabBarView: UIView, NibLoadableView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var notesButton: UIButton!
    @IBAction func pressNotesButton(_ sender: UIButton) {
    }
    
    @IBOutlet weak var addButton: UIButton!
    @IBAction func pressAddButton(_ sender: UIButton) {
        delegate?.pressAddButton()
    }
    
    
    weak var delegate: TabBarViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        addSubview(contentView)
        self.initAppearance()
    }
        
    
    internal func initAppearance() {
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.shadow(cornerRadius: 25)
        
    }
}
