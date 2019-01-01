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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        saveItems()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Mark - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "To do List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){(action) in
            if textField.text != ""{
                let newItem   = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Encoding Error")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("decoding error")
            }
                    }
    }

}
