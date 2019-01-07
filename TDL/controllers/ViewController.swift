//
//  ViewController.swift
//  TDL
//
//  Created by Nauman Bajwa on 12/30/18.
//  Copyright © 2018 Nauman Bajwa. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    // var itemArray = ["Pray","Study","Gym"]
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK- tableview data course methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    
    // MARK - table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems? [indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Mark - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "To do List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){(action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error in saving \(error)")
                }
            }
           self.tableView.reloadData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    
}/*
 // Mark: search bar methods
 extension ViewController: UISearchBarDelegate {
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 //    let request : NSFetchRequest<Item> = Item.fetchRequest()
 
 //     let categoryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
 //     let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate ])
 //     request.predicate = compoundPredicate
 
 //     let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
 //    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
 //   loadItems(with: request, predicate: predicate)
 
 }
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 if searchBar.text?.count == 0 {
 //       loadItems()
 DispatchQueue.main.async {
 searchBar.resignFirstResponder()
 }
 
 }
 }/
 }*/
