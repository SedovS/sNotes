//
//  CardVC.swift
//  sNotes
//
//  Created by Apple on 30.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class CardVC: UIViewController {

    enum ActionsForCard {
        case add
        case show
        case hide
    }
    
    @IBOutlet weak var cardInfoView: UIView!
    @IBOutlet weak var nameCardInfoLabel: UILabel!
    @IBOutlet weak var actionsCardButton: UIButton!
    
    @IBOutlet weak var numberCard: UITextField!
    @IBOutlet weak var dateCard: UITextField!
    @IBOutlet weak var cvcCard: UITextField!
    @IBOutlet weak var cardOwner: UITextField!
    @IBOutlet weak var pinCard: UITextField!
    
    var isAddCard = false
    var isShowCard = true
    var card: CardDM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameCardInfoLabel.text = "Реквезиты карты"
        numberCard.placeholder = ""
        dateCard.placeholder = ""
        cvcCard.placeholder = ""
        cardOwner.placeholder = ""

        cardInfoView.shadow()
        let titleButton = isAddCard ? "Добавить" : "Показать"
        actionsCardButton.setTitle(titleButton, for: .normal)
        
        if isAddCard {
            numberCard.placeholder = "Номер карты"
            dateCard.placeholder = "Срок действия"
            cvcCard.placeholder = "CVC"
            cardOwner.placeholder = "Имя держателя"
            pinCard.placeholder = "pin"
            numberCard.delegate = self
            cardOwner.delegate = self
            cvcCard.delegate = self
            dateCard.delegate = self
        } else {
            numberCard.isUserInteractionEnabled = false
            dateCard.isUserInteractionEnabled = false
            cvcCard.isUserInteractionEnabled = false
            cardOwner.isUserInteractionEnabled = false
            hideCardInfo()
            card?.changeDateLastOpen()
        }
        
        pinCard.delegate = self
        
//        gray(field: numberCard)
//        gray(field: dateCard)
//        gray(field: cvcCard)
//        gray(field: cardOwner)

    }
    
    @IBAction func pressActionsCardButton(_ sender: UIButton) {
        if isAddCard {
            checkForCorrect()
        } else {
            let titleButton = isShowCard ? "Скрыть" : "Показать"
            actionsCardButton.setTitle(titleButton, for: .normal)
            isShowCard ? showCardInfo() : hideCardInfo()
            isShowCard = !isShowCard
        }
    }
    
    private func checkForCorrect() {
        
        guard let number = numberCard.text?.replacingOccurrences(of: " ", with: ""),
            number.count == 16 else {
                redBorderTextField(field: numberCard)
                return
        }
        guard let date = dateCard.text,
            date != "", Int(date[0...1]) ?? 13 <= 12, let _ = Day.convertStringDateFromCardToDate(date: date) else {
                redBorderTextField(field: dateCard)
                return
        }
        guard let cvc = Int(cvcCard.text ?? ""),
            cvcCard.text?.count == 3 else {
                redBorderTextField(field: cvcCard)
                return
        }
        guard let name = cardOwner.text,
            name != "" else {
                redBorderTextField(field: cardOwner)
                return
        }
        CardDM.addCard(last4Number: String(number.suffix(4)), date: date, cardOwner: name, firstNumber: number[0...0])
        dismiss(animated: true, completion: nil)
        
    }
    
    private func hideCardInfo() {
        numberCard.text = "\u{00B7}\u{00B7}\u{00B7}\u{00B7} \u{00B7}\u{00B7}\u{00B7}\u{00B7} \u{00B7}\u{00B7}\u{00B7}\u{00B7} " + (card?.last4Number ?? "")
        dateCard.text = "\u{00B7}\u{00B7}/\u{00B7}\u{00B7}"
        cvcCard.text = "\u{00B7}\u{00B7}\u{00B7}"
        cardOwner.text = card?.cardOwner
        pinCard.text = "\u{00B7}\u{00B7}\u{00B7}\u{00B7}"
    }
    
    private func showCardInfo() {
        numberCard.text = "**** **** **** " + (card?.last4Number ?? "")
        dateCard.text = card?.date
        cvcCard.text = "***"
        cardOwner.text = card?.cardOwner
        pinCard.text = "\u{00B7}\u{00B7}\u{00B7}\u{00B7}"
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
        field.becomeFirstResponder()
    }
    
}

extension CardVC: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardOwner:
            self.checkForCorrect()
        default:
            return true
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == numberCard {
            switch textField.text?.count  {
            case 4, 9, 14:
                textField.text! += " "
            default:
                break
            }
        }
        
        if textField == dateCard {
            if textField.text?.count == 2 {
                 textField.text! += "/"
            }
        }
        
        if textField == pinCard {
            //save pincode
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if textField == numberCard {
                
            } else if textField.text?.count == 4 {
                textField.text?.removeLast(2)
                return true
            }

            return true
        }
        switch textField {
        case numberCard:
            if textField.text?.replacingOccurrences(of: " ", with: "").count ?? 0 >= 16 {
                return false
            }
        case dateCard:
            if textField.text?.replacingOccurrences(of: "/", with: "").count ?? 0 >= 4 {
                return false
            }
        case cvcCard:
            if textField.text?.count ?? 0 >= 3 {
                return false
            }
        case pinCard:
            if textField.text?.count ?? 0 >= 4 {
                return false
            }
        default:
            return false
        }
        return true
    }
}
