//
//  PasswordDM+CoreDataProperties.swift
//  sNotes
//
//  Created by Apple on 31.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension PasswordDM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PasswordDM> {
        return NSFetchRequest<PasswordDM>(entityName: "PasswordDM")
    }

    @NSManaged public var website: String
    @NSManaged public var login: String
    @NSManaged public var descriptionPassword: String?
    @NSManaged public var dateCreate: Date
    @NSManaged public var dateLastOpen: Date
    @NSManaged public var profile: ProfileDM?

}
