//
//  ViewController.swift
//  TDL
//
//  Created by Nauman Bajwa on 12/30/18.
//  Copyright © 2018 Nauman Bajwa. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
   // var itemArray = ["Pray","Study","Gym"]
    var itemArray   = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
     //      itemArray = items}
       let newItem = Item()
        newItem.title = "Prayers"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Studies"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "IOS"
        itemArray.append(newItem3)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK- tableview data course methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    // MARK - table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
      // to change the check property of the item
     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
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
                
            
            let newItem   = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
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

