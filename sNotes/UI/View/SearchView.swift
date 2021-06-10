//
//  SearchView.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    func changeSearchtextField(text: String)
    func pressProfileButton()
}

class SearchView: UIView, NibLoadableView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: SearchViewDelegate?
    var isNotesView = true
    @IBAction func pressProfileButton(_ sender: UIButton) {
        delegate?.pressProfileButton()
    }
    
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
        contentView.shadow(cornerRadius: 15)
        
        profileButton.cornerRadius = profileButton.frame.width / 2
        profileButton.setImage(ProfileDM.getPhotoProfile(), for: .normal)
        
        textField.delegate = self
        textField.placeholder = isNotesView ? NSLocalizedString("FindYourNote", comment: "") : NSLocalizedString("FindAmongData", comment: "")
        
        //for ios 13+ textFieldDidChangeSelection
        if #available(iOS 13.0, *) {
        } else {
            textField.addTarget(self, action: #selector(SearchView.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        changeText(textField: textField)
    }
    private func changeText(textField: UITextField) {
        delegate?.changeSearchtextField(text: textField.text ?? "")
    }
}

extension SearchView: UITextFieldDelegate {
    
    //on ios 13+
    func textFieldDidChangeSelection(_ textField: UITextField) {
       changeText(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.contentView.endEditing(true)
        return false
    }
    
}
