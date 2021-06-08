//
//  NoteDM+CoreDataProperties.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteDM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteDM> {
        return NSFetchRequest<NoteDM>(entityName: "NoteDM")
    }

    @NSManaged public var dateCreate: Date
    @NSManaged public var dateLastChange: Date
    @NSManaged public var dateLastOpen: Date
    @NSManaged public var dateReminder: Date?

    @NSManaged public var isAnchor: Bool
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var profile: ProfileDM?
    @NSManaged public var folder: FolderDM?

}
