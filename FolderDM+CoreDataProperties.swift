//
//  FolderDM+CoreDataProperties.swift
//  sNotes
//
//  Created by Apple on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension FolderDM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderDM> {
        return NSFetchRequest<FolderDM>(entityName: "FolderDM")
    }

    @NSManaged public var name: String
    @NSManaged public var color: NSObject?
    @NSManaged public var isAnchore: Bool
    @NSManaged public var dateCreate: Date
    @NSManaged public var dateLastOpen: Date
    @NSManaged public var dateLastChange: Date
    @NSManaged public var isDefaultFolder: Bool
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension FolderDM {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteDM)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteDM)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
