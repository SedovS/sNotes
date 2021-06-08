//
//  SetPassCodeVC.swift
//  sNotes
//
//  Created by Apple on 29.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import LocalAuthentication

class SetPassCodeVC: UIViewController {

    enum PassCodeColor {
        case blue
        case red
        case clear
    }
    
    enum TextForNameLabel: String {
        case enterPasssCode = "Введите пароль"
        case setPassCode = "Задайте код доступа"
        case repearPassCode = "Повторите код доступа"
    }
    
    enum TextForHintLabel: String {
        case standart = "Он будет использоваться для входа в приложение"
        case wrongRepeatPassCode = "Пароли не совпали. \n Повторите попытку"
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var passCodeSymbolsView: UIView!
    @IBOutlet weak var passCodeKeyboardView: UIView!
    @IBOutlet var passCodeSymbols: [UIView]!
    @IBOutlet weak var forgotPassCodeButton: UIButton!
    @IBOutlet weak var faceTouchIDButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet var passCodeKeyboards: [UIButton]!
    
    private var passcodeStack = String()
    private var enteredPasscode = String()
    private var isRepeatingEnterPasscode = false
    private var isEnterPassCode = true
    private var timeBlock = CheckBlockSingnin()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEnterPassCode = WorkWithKeychain.isPasscode()
        
        for el in passCodeSymbols {
            setColorForPassCodeSymbol(view: el, color: .clear)
        }
        forgotPassCodeButton.isHidden = !isEnterPassCode
        forgotPassCodeButton.setTitle("Выйти", for: .normal)
        aboutButton.setTitle("Зачем?", for: .normal)
        aboutButton.isHidden = !isEnterPassCode
        faceTouchIDButton.isHidden = !isEnterPassCode
        
        nameLabel.text = isEnterPassCode ? TextForNameLabel.enterPasssCode.rawValue : TextForNameLabel.setPassCode.rawValue
        hintLabel.isHidden = isEnterPassCode
        let isAuthenticationWithBiometrics = ProfileDM.getIsAuthenticationWithBiometrics()
        
        faceTouchIDButton.isHidden = !isAuthenticationWithBiometrics
        if isEnterPassCode && isAuthenticationWithBiometrics && !timeBlock.isBlock() {
            showID()
        }
    }
    
    override func viewWillLayoutSubviews() {
        setBorderForpassCodeKeyboards()
    }

    @IBAction func pressButtonOnKeyboard(_ sender: UIButton) {
        if timeBlock.isBlock(view: self) {
            clearPassCodeWithError()
            return
        }
        switch passcodeStack.count {
        case 0..<5:
            setColorForPassCodeSymbol(view: passCodeSymbols[passcodeStack.count], color: .blue)
            passcodeStack.append(String(sender.tag))
        case 5:
            setColorForPassCodeSymbol(view: passCodeSymbols[passcodeStack.count], color: .blue)
            passcodeStack.append(String(sender.tag))
            
            if isEnterPassCode {
                self.timeBlock.changeCount()
                if self.timeBlock.isBlockCount(view: self) {
                    clearPassCodeWithError()
                    return
                }
                 passCodeKeyboardView.isUserInteractionEnabled = false
                
                //сравнение на корректность
                if WorkWithKeychain.checkPassCode(passCode: passcodeStack) {
                    self.timeBlock.resetCountOfAttemptsSignin()
                    let vc = NotesVC()
                    UIApplication.shared.keyWindow?.rootViewController = vc

                } else {

                    for el in self.passCodeSymbols {
                        self.setColorForPassCodeSymbol(view: el, color: .red)
                    }
                    passcodeStack = String()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        self.resetPassCodeBackground()
                        self.passCodeKeyboardView.isUserInteractionEnabled = true
                    }

                }
            } else if !isRepeatingEnterPasscode {
                repeatPassCode(passcode: passcodeStack)
            } else {
                if enteredPasscode == passcodeStack {
                    WorkWithKeychain.setPassCode(passCode: passcodeStack)
                    let vc = SetPassCodeVC()
                    UIApplication.shared.keyWindow?.rootViewController = vc
                } else {
                    for el in self.passCodeSymbols {
                        self.setColorForPassCodeSymbol(view: el, color: .red)
                    }
                    
                    nameLabel.isHidden = true
                    nameLabel.text = TextForNameLabel.setPassCode.rawValue
                    hintLabel.text = TextForHintLabel.wrongRepeatPassCode.rawValue
                    hintLabel.isHidden = false

                    isRepeatingEnterPasscode = false
                    passcodeStack = String()
                    passCodeKeyboardView.isUserInteractionEnabled = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        self.resetPassCodeBackground()
                        self.hintLabel.text = TextForHintLabel.standart.rawValue
                        self.nameLabel.isHidden = false
                        self.passCodeKeyboardView.isUserInteractionEnabled = true
                    }
                }
            }
            
        default:
            break
        }
    }
    
    
    @IBAction func pressDeleteButton(_ sender: Any) {
        if !passcodeStack.isEmpty {
            setColorForPassCodeSymbol(view: passCodeSymbols[passcodeStack.count-1], color: .clear)
            passcodeStack.removeLast()
        }
    }
    
    
    @IBAction func pressFaseTouchID(_ sender: UIButton) {
        showID()
    }
    
    @IBAction func pressForgotPassword(_ sender: Any) {
        let alert = UIAlertController.createLogOutAlert(WithTitle: "Вы уверены, что хотите выйти?", message: "Все ваши данные придется удалить.") {
            PersistenceManager.shared.deleteAll()
            WorkWithKeychain.clearKeychain()
            AppDelegate().start(window: UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
        }
        show(alert, sender: nil)
    }
    
    @IBAction func pressAboutButton(_ sender: UIButton) {
    }
    
    private func clearPassCodeWithError() {
        for el in self.passCodeSymbols {
            self.setColorForPassCodeSymbol(view: el, color: .red)
        }
        passcodeStack = String()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.resetPassCodeBackground()
            self.passCodeKeyboardView.isUserInteractionEnabled = true
        }
    }
        
    private func repeatPassCode(passcode: String) {
        enteredPasscode = passcode
        isRepeatingEnterPasscode = true
        resetPassCodeBackground()
        nameLabel.text = TextForNameLabel.repearPassCode.rawValue
        hintLabel.isHidden = true
        passcodeStack = String()
    }
    
    private  func resetPassCodeBackground() {
        DispatchQueue.main.async {
            for el in self.passCodeSymbols {
                self.setColorForPassCodeSymbol(view: el, color: .clear)
            }
        }
        
    }
    
    private func setBorderForpassCodeKeyboards() {
        for el in passCodeKeyboards {
            el.cornerRadius = el.frame.height / 2
            el.borderWidth = 2
            el.borderColor = .lightGray
        }
    }
    
    private func setColorForPassCodeSymbol(view: UIView, color: PassCodeColor) {
        view.cornerRadius = view.frame.height / 2
        switch color {
        case .clear:
            view.backgroundColor = .clear
            view.borderColor = .customBlueForPassCode()
            view.borderWidth = 2
        case .blue:
            view.backgroundColor = .customBlueForPassCode()
        case .red:
            view.borderColor = .red
            view.backgroundColor = .red
        }
    }
    
    private func showID() {
        usleep(200000)
        let context = LAContext()
        context.localizedCancelTitle = "Отменить"
        
        // First check if we have the needed hardware support.
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Приложите палец для входа в приложение"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in
                
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        let vc = NotesVC()
                        UIApplication.shared.keyWindow?.rootViewController = vc
                    }
                } else {
                }
            }
        } else {
        }
    }
}
