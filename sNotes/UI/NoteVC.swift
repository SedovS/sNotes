//
//  NoteVC.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class NoteVC: UIViewController {

    @IBOutlet weak var nameFolderButton: UIButton!
    
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var titleNote: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBAction func swipedLeft(_ sender: UIScreenEdgePanGestureRecognizer) {
        let vc = NotesVC()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
//    var folder: FolderDM?
    var note: NoteDM?
    var isCrateNote = false

    fileprivate lazy var arrayFolders: [FolderDM] = {
        return FolderDM.getFolders()
    }()
    

    let arrayNameImage = [/*"icAddCheckList", "icAddImage", "icAddAudio", */"icAddReminder", "icPin"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        note?.changLDateLastOpen()
        nameFolderButton.setTitle(note?.folder?.name ?? "no name folder", for: .normal)
        let color = note?.folder?.color as? UIColor ?? .customGrayForArray()
        nameFolderButton.imageView?.image = CustomImage.image(color: color)
        titleNote.text = note?.title
        textView.text = ChaChaPolyHelpers.decrypt(encryptedContent: note?.text)
        if titleNote.text == nil ||  titleNote.text == "" {
            titleNote.placeholder = NSLocalizedString("EnterName", comment: "")
            titleNote.becomeFirstResponder()
        }
        
        if isCrateNote {
            titleNote.becomeFirstResponder()
        }
        
        tabBarView.delegate = self

        titleNote.delegate = self
        textView.delegate = self
                
        //pickerView
        pickerView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //datePickerView
        datePickerView.isHidden = true
        if false {
            datePickerView.locale = Locale(identifier: "en-GB")
        }
        if #available(iOS 14, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        datePickerView.datePickerMode = .dateAndTime

        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.registerCell(IconCell.self)
        tableView.backgroundColor = .customBlueForTableView()
        tableView.cornerRadius = 21
        tableView.isScrollEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.sz_heightConstraint()?.constant = tableView.contentSize.height
        tableView.sz_trailingConstraint()?.constant = self.view.frame.width/8 - 52/2
        tableView.cornerRadius = tableView.frame.width / 2
    }


    @IBAction func pressNameFolderButton(_ sender: UIButton) {
        if arrayFolders.count > 1 {
            pickerView.isHidden = false
        }
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        note?.changedateReminder(date: sender.date)
        NotificationManager.shared.addLocalPushForNotes()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.isHidden = true
        datePickerView.isHidden = true
    }
    
}

//MARK:- TapBarViewDelegate
extension NoteVC: TabBarViewDelegate {
    func pressAddButton() {
        tableView.isHidden = false
    }
}

//MARK:- UITextFieldDelegate
extension NoteVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        note?.changeTitle(newTitle: textField.text ?? "")
        note?.changeDeteLastChange()
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        note?.changeTitle(newTitle: textField.text ?? "")
        note?.changeDeteLastChange()
    }

}

extension NoteVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.changeDeteLastChange()
        note?.changeText(newText: textView.text)
    }
}



//MARK:- UITableViewDataSource
extension NoteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayNameImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as IconCell
        if arrayNameImage[indexPath.row] == "icPin" && note?.isAnchor ?? false {
                cell.icon.image = UIImage(named: "icUnPin")
                return cell
        }
        cell.icon.image = UIImage(named: arrayNameImage[indexPath.row])
        return cell
    }
    
}

//MARK:- UITableViewDelegate
extension NoteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        
        switch arrayNameImage[indexPath.row] {
        case "icAddCheckList": break
        case "icAddImage": break
        case "icAddAudio": break

        case "icAddReminder":
            if note?.dateReminder != nil {
                datePickerView.setDate(note?.dateReminder ?? Date(), animated: false)
            }
            datePickerView.isHidden = false
        case "icPin":
            note?.changeAnchor()
            note?.changeDeteLastChange()
        default:
            break
        }
        tableView.isHidden = true
        tableView.reloadData()
    }
}

//MARK:- UIPickerViewDataSource
extension NoteVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayFolders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayFolders[row].name
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        note?.changeFolder(newFolder: arrayFolders[row])
        note?.folder?.changeDateLastChange()
        nameFolderButton.setTitle(note?.folder?.name ?? "", for: .normal)
        nameFolderButton.imageView?.image = CustomImage.image(color: note?.folder?.color as? UIColor ?? .customGrayForArray())
        
    }
    
}
