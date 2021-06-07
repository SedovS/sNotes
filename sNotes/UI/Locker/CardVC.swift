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
    @IBOutlet weak var paymentSystem: UIImageView!
    
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
            numberCard.delegate = self
            cardOwner.delegate = self
        } else {
            numberCard.isUserInteractionEnabled = false
            dateCard.isUserInteractionEnabled = false
            cvcCard.isUserInteractionEnabled = false
            cardOwner.isUserInteractionEnabled = false
            hideCardInfo()
            card?.changeDateLastOpen()
        }
        
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
        
        guard let number = numberCard.text,
            numberCard.text?.count == 16 else {
                redBorderTextField(field: numberCard)
                return
        }
        guard let date = dateCard.text,
            date != "" else {
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
    }
    
    private func showCardInfo() {
        numberCard.text = "**** **** **** " + (card?.last4Number ?? "")
        dateCard.text = card?.date
        cvcCard.text = "***"
        cardOwner.text = card?.cardOwner
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
}
