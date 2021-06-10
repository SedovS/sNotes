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
    
    var arrayNotes = NoteDM.getNotesForReminder()
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as ReminderCell
        cell.initCell(date: arrayNotes[indexPath.row].dateReminder!, name: arrayNotes[indexPath.row].title ?? "")
        return cell
    }
    
    
}

extension ReminderVC: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            self.arrayNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.image = UIImage(systemName: "trash")
//        deleteAction.backgroundColor = .customRedForArray()
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    
}

extension ReminderVC: NSFetchedResultsControllerDelegate {
    
}
