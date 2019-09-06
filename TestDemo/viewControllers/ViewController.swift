//
//  ViewController.swift
//  TestDemo
//
//  Created by Federico Lopez on 30/08/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var dataProvider = DataProvider()
    var data: [String] = []
    
    @IBOutlet weak var prevEntriesList: UITableView!
    @IBOutlet weak var newEntryTextField: UITextField!

    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        reloadData()
    }
    
    func setupComponents() {
        newEntryTextField.delegate = self
        
        prevEntriesList.delegate = self
        prevEntriesList.dataSource = self
        prevEntriesList.removeEmptyCells()
        prevEntriesList.register(TextTableViewCell.self, forCellReuseIdentifier: ENTRY_CELL_ID)
    }
    
    
    // MARK: - Data
    func reloadData() {
        dataProvider.getAllEntries { (objs) in
            if let entries = objs {
                data = entries
                prevEntriesList.reloadData()
            }
        }
    }
    
    
    // MARK: - Event(s)
    @IBAction func submitOnPress(_ sender: UIButton) {
        dataProvider.addNewEntry(newEntryTextField.text!) { (success, repeated) in
            if(success) {
                reloadData()
                newEntryTextField.text = ""
            } else if(repeated) {
                ALERT("Error saving", "You already entered that value.\nTry a different one", viewController: self)
            }
        }
    }

}


// MARK: - UITextField misc
extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = BUILD_NEW_TEXT(from: textField.text!, inRange: range, using: string)
        if(VALIDATE_ENTRY(newText)) {
            return false
        }
        
        return newText.count <= ENTRY_CHAR_LIMIT
    }
}


// MARK: - UITableView misc
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENTRY_CELL_ID, for: indexPath) as! TextTableViewCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let text = self.data[indexPath.row]
            self.dataProvider.removeEntryWithText(text, callback: { (success) in
                if(success) {
                    self.reloadData()
                }
            })
        }
        return [deleteAction]
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newEntryTextField.text = data[indexPath.row]
        prevEntriesList.deselectAll(delay: 0.2)
    }
    
}



