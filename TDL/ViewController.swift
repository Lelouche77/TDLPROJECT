//
//  ViewController.swift
//  TDL
//
//  Created by Nauman Bajwa on 12/30/18.
//  Copyright © 2018 Nauman Bajwa. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = ["Pray","Study","Gym"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK- tableview data course methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    // MARK - table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
       tableView.deselectRow(at: indexPath, animated: true)
    }
    //Mark - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "To do List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){(action) in
            // what will happen if the user clicks add item button on UI alert
           // print("Success!")
           // print(textField.text!)
            if textField.text != ""{
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            }
            
        }
            
            alert.addTextField{ (alertTextField) in
                alertTextField.placeholder = "Create New Item"
               
                textField = alertTextField
            }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

