//
//  CardDM+CoreDataClass.swift
//  sNotes
//
//  Created by Apple on 30.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


public class CardDM: NSManagedObject {

}

extension CardDM {
    
    static func addCard(last4Number: String, date: String, cardOwner: String, firstNumber: String) -> CardDM {
        let persistenceManager = PersistenceManager.shared
        let cardDM = CardDM(context: persistenceManager.context)

        
        cardDM.last4Number = last4Number
        cardDM.date = date
        cardDM.cardOwner = cardOwner.uppercased()
        cardDM.paymentSystem = PaymentSystem().namePS(firstNumberCard: firstNumber)
//        cardDM.nameBank: String?
        cardDM.dateAddCard = Date()
        cardDM.dateLastOpen = Date()
        cardDM.dateExpiration = Day.convertStringDateFromCardToDate(date: date)
//        cardDM.comment: String?

        cardDM.profile = ProfileDM.getProfile()
        persistenceManager.saveContext()
        return cardDM
    }
    
    static func getCards() -> [CardDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<CardDM> = CardDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateLastOpen", ascending: false)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    func changeDateLastOpen(date: Date = Date()) {
        self.dateLastOpen = date
        PersistenceManager.shared.saveContext()
    }

}
