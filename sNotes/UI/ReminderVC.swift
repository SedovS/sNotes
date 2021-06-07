//
//  ReminderVC.swift
//  sNotes
//
//  Created by Apple on 31.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import CoreData

class ReminderVC: UIViewController {
    
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var reminderTableView: UITableView!
    
    fileprivate lazy var frc: NSFetchedResultsController<NoteDM> = {
        let context = PersistenceManager.shared.context
        
        let fetchRequest : NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateReminder", ascending: false)]
        let tmpFrc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "dateReminder", cacheName: nil)
//        tmpFrc.delegate = self
//        try? tmpFrc.performFetch()
        return tmpFrc
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tabBarView.delegate = self
        tabBarView.reminderSelected()
        
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        
        reminderTableView.registerCell(ReminderCell.self)
        reminderTableView.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension ReminderVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = frc.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else { return nil }
        return sections[section].indexTitle ?? ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as ReminderCell
        cell.initCell(date: Date(), name: "Test")
        return cell
    }
    
    
}

extension ReminderVC: UITableViewDelegate {
    
}

extension ReminderVC: NSFetchedResultsControllerDelegate {
    
}
