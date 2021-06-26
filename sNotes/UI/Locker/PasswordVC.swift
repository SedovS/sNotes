//
//  PasswordVC.swift
//  sNotes
//
//  Created by Apple on 31.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {
    
    @IBOutlet weak var passwordInfoView: UIView!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var actionsPasswordButton: UIButton!
    
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var descriptionPassword: UITextField!
    
    
    @IBOutlet weak var generatePasswordButton: UIButton!
    var isAddPassword = false
    var isShowPassword = true
    var passwordDM: PasswordDM?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordInfoLabel.text = NSLocalizedString("Passord", comment: "")
        website.placeholder = ""
        login.placeholder = ""
        password.placeholder = ""
        descriptionPassword.placeholder = ""

        passwordInfoView.shadow()
        let titleButton = isAddPassword ? NSLocalizedString("Add", comment: "") : NSLocalizedString("Show", comment: "")
        actionsPasswordButton.setTitle(titleButton, for: .normal)
        
        generatePasswordButton.isHidden = true
        generatePasswordButton.sz_heightConstraint()?.constant = 0
        generatePasswordButton.sz_bottomConstraint()?.constant = 0
        generatePasswordButton.sz_topConstraint()?.constant = 20
        
        if isAddPassword {
            website.placeholder = NSLocalizedString("Website", comment: "")
            login.placeholder = NSLocalizedString("Login", comment: "")
            password.placeholder = NSLocalizedString("Passord", comment: "")
            descriptionPassword.placeholder = NSLocalizedString("Description", comment: "")
            
            website.delegate = self
            login.delegate = self
            password.delegate = self
            descriptionPassword.delegate = self
            
            website.becomeFirstResponder()

            
            generatePasswordButton.setTitle(NSLocalizedString("GenerateStrongPassword", comment: ""), for: .normal)
            generatePasswordButton.titleLabel?.textColor = .customBlueForProfile()
            generatePasswordButton.backgroundColor = .customGrayForProfile()
            generatePasswordButton.shadow()
        } else {
            website.isUserInteractionEnabled = false
            login.isUserInteractionEnabled = false
            password.isUserInteractionEnabled = false
            descriptionPassword.isUserInteractionEnabled = false
            
            website.text = passwordDM?.website
            login.text = ChaChaPolyHelpers.decrypt(encryptedContent: passwordDM?.login)
                

            hidePasswordInfo()
        }
        
    }
    
    
    @IBAction func pressActionsPassword(_ sender: UIButton) {
        if isAddPassword {
            checkForCorrect()
        } else {
            let titleButton = isShowPassword ? NSLocalizedString("Hide", comment: "") : NSLocalizedString("Show", comment: "")
            actionsPasswordButton.setTitle(titleButton, for: .normal)
            isShowPassword ? showPasswordInfo() : hidePasswordInfo()
            isShowPassword = !isShowPassword
        }
    }
    
    
    @IBAction func pressGeneratePasswordButton(_ sender: Any) {
        //
        password.text = SecCreateSharedWebCredentialPassword() as? String //"REDAS-Edcsdg-EsddE-Reew"
        descriptionPassword.becomeFirstResponder()
        UIPasteboard.general.string = password.text
    }
    
    private func checkForCorrect() {
        guard let website = website.text, website != "" else {
            redBorderTextField(field: self.website)
            return
        }
        guard let login = login.text, login != "" else {
            redBorderTextField(field: self.login)
            return
        }
        guard let password = password.text, password != "" else {
            redBorderTextField(field: self.password)
            return
        }
        passwordDM = PasswordDM.addPassword(website: website, login: login, descriptionPassword: descriptionPassword.text)
        WorkWithKeychain.setService(key: .password, addService: passwordDM?.objectID.uriRepresentation().path ?? "", data: password)
        dismiss(animated: true, completion: nil)
    }
    
    
    private func hidePasswordInfo() {
        password.text = "\u{00B7} \u{00B7} \u{00B7} \u{00B7}"
        descriptionPassword.text = "\u{00B7} \u{00B7} \u{00B7} \u{00B7}"
    }
    
    private func showPasswordInfo() {
        password.text = WorkWithKeychain.getService(key: .password, addService: passwordDM?.objectID.uriRepresentation().path ?? "")
        descriptionPassword.text = ChaChaPolyHelpers.decrypt(encryptedContent: passwordDM?.descriptionPassword)
            
    }
    
    private func gray(field: UITextField) {
        //        field.borderColor = .lightGray
        //        field.borderWidth = 2
        field.cornerRadius = 8
    }
    
    private func redBorderTextField(field: UITextField) {
        field.borderColor = .red
        field.borderWidth = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            field.borderColor = .clear
        }
    }

}

extension PasswordVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == password {
            generatePasswordButton.isHidden = false
            generatePasswordButton.sz_heightConstraint()?.constant = 44
            generatePasswordButton.sz_bottomConstraint()?.constant = 16
            generatePasswordButton.sz_topConstraint()?.constant = 44
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == password {
            generatePasswordButton.isHidden = true
            generatePasswordButton.sz_heightConstraint()?.constant = 0
            generatePasswordButton.sz_bottomConstraint()?.constant = 0
            generatePasswordButton.sz_topConstraint()?.constant = 20
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case website:
            login.becomeFirstResponder()
        case login:
            password.becomeFirstResponder()
        case password:
            descriptionPassword.becomeFirstResponder()
        case descriptionPassword:
            self.checkForCorrect()
        default:
            return false
        }
        return true
    }
}
