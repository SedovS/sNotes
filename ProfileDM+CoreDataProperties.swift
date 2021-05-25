//
//  ProfileDM+CoreDataProperties.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData

extension ProfileDM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileDM> {
        return NSFetchRequest<ProfileDM>(entityName: "ProfileDM")
    }

    @NSManaged public var userName: String?
    @NSManaged public var userSurname: String?
    @NSManaged public var photoProfile: Data?
    @NSManaged public var notes: NSSet?
    @NSManaged public var cards: NSSet?
    @NSManaged public var passwords: NSSet?
    
    

}

// MARK: Generated accessors for notes
extension ProfileDM {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteDM)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteDM)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for cards
extension ProfileDM {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: NSManagedObject)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: NSManagedObject)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for passwords
extension ProfileDM {

    @objc(addPasswordsObject:)
    @NSManaged public func addToPasswords(_ value: NSManagedObject)

    @objc(removePasswordsObject:)
    @NSManaged public func removeFromPasswords(_ value: NSManagedObject)

    @objc(addPasswords:)
    @NSManaged public func addToPasswords(_ values: NSSet)

    @objc(removePasswords:)
    @NSManaged public func removeFromPasswords(_ values: NSSet)

}
