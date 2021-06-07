//
//  CardDM+CoreDataProperties.swift
//  sNotes
//
//  Created by Apple on 30.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension CardDM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardDM> {
        return NSFetchRequest<CardDM>(entityName: "CardDM")
    }

    @NSManaged public var last4Number: String
    @NSManaged public var date: String
    @NSManaged public var cardOwner: String
    @NSManaged public var paymentSystem: String?
    @NSManaged public var nameBank: String?
    @NSManaged public var dateAddCard: Date
    @NSManaged public var dateLastOpen: Date
    @NSManaged public var dateExpiration: Date?
    @NSManaged public var comment: String?
    @NSManaged public var profile: ProfileDM?

}
