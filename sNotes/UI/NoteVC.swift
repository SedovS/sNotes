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
    @IBOutlet weak var titileNote: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var folder: FolderDM?
    var note: NoteDM?
    
    fileprivate lazy var arrayFolders: [FolderDM] = {
        return FolderDM.getFolders()
    }()
    

    let arrayNameImage = [/*"icAddCheckList", "icAddImage", "icAddAudio", */"icPin"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameFolderButton.titleLabel?.text = note?.folder?.name ?? "no name folder"
        nameFolderButton.imageView?.image = CustomImage.image(color: .customGrayForArray())
        
        
        tabBarView.delegate = self

        
        //pickerView
        pickerView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.registerCell(IconCell.self)
        tableView.backgroundColor = .customBlueForTableView()
        tableView.cornerRadius = 21
        tableView.isScrollEnabled = false
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        tableView.sz_heightConstraint()?.constant = tableView.contentSize.height
        tableView.sz_trailingConstraint()?.constant = self.view.frame.width/8 - 52/2
    }


    @IBAction func pressNameFolderButton(_ sender: UIButton) {
        pickerView.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.isHidden = true
    }

    
}

//MARK:- TapBarViewDelegate
extension NoteVC: TabBarViewDelegate {
    func pressAddButton() {
        tableView.isHidden = false
    }
}


//MARK:- UITableViewDataSource
extension NoteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayNameImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as IconCell
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

        case "icPic":
            note?.addToAnchor()
        default:
            return
        }
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
        
        //
//        note?.changeFolder(newFolder: arrayFolders[row])
//        nameFolderButton.titleLabel?.text = note?.folder?.name ?? "no name folder"
//        nameFolderButton.imageView?.image = CustomImage.image(color: .customGrayForArray())
        
    }
    
}
