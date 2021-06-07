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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var descriptionPassword: UITextField!
    
    var isAddPassword = false
    var isShowPassword = true
    var passwordDM: PasswordDM?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordInfoLabel.text = "Пароль"
        website.placeholder = ""
        email.placeholder = ""
        password.placeholder = ""
        descriptionPassword.placeholder = ""

        passwordInfoView.shadow()
        let titleButton = isAddPassword ? "Добавить" : "Показать"
        actionsPasswordButton.setTitle(titleButton, for: .normal)
        
        if isAddPassword {
            website.placeholder = "Сайт"
            email.placeholder = "Почта"
            password.placeholder = "Пароль"
            descriptionPassword.placeholder = "Описание"
            
            website.delegate = self
            email.delegate = self
            password.delegate = self
            descriptionPassword.delegate = self
        } else {
            website.isUserInteractionEnabled = false
            email.isUserInteractionEnabled = false
            password.isUserInteractionEnabled = false
            descriptionPassword.isUserInteractionEnabled = false
            
            website.text = passwordDM?.website
            email.text = passwordDM?.email

            hidePasswordInfo()
        }
        
    }
    
    
    @IBAction func pressActionsPassword(_ sender: UIButton) {
        if isAddPassword {
            checkForCorrect()
        } else {
            let titleButton = isShowPassword ? "Скрыть" : "Показать"
            actionsPasswordButton.setTitle(titleButton, for: .normal)
            isShowPassword ? showPasswordInfo() : hidePasswordInfo()
            isShowPassword = !isShowPassword

        }
        
    }
    
    private func checkForCorrect() {
        guard let website = website.text, website != "" else {
            redBorderTextField(field: self.website)
            return
        }
        guard let email = email.text, email != "" else {
            redBorderTextField(field: self.email)
            return
        }
        guard let password = password.text, password != "" else {
            redBorderTextField(field: self.password)
            return
        }
        PasswordDM.addPassword(website: website, email: email, descriptionPassword: descriptionPassword.text)
        dismiss(animated: true, completion: nil)
    }
    
    
    private func hidePasswordInfo() {
        password.text = "***"
        descriptionPassword.text = ""
    }
    
    private func showPasswordInfo() {
        password.text = "***"
        descriptionPassword.text = passwordDM?.descriptionPassword
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
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case website:
            email.becomeFirstResponder()
        case email:
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
