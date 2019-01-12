//
//  ViewController.swift
//  TDL
//
//  Created by Nauman Bajwa on 12/30/18.
//  Copyright © 2018 Nauman Bajwa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ViewController: SwipeTableViewController {
    
    // var itemArray = ["Pray","Study","Gym"]
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
       title = selectedCategory?.name
         guard let colorHex = selectedCategory?.colour  else {fatalError()}
        updateNavBar(withHexCode: colorHex)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
      updateNavBar(withHexCode: "1D9BF6")
    }
    // Mark: - Nav bar setup methods
    func updateNavBar(withHexCode colorHexCode: String){

        guard let navBar   = navigationController?.navigationBar else {fatalError()}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = UIColor(hexString: colorHexCode)
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHexCode), isFlat: true)
        searchBar.barTintColor = UIColor(hexString: colorHexCode)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)]
    }
    
    
    // MARK- tableview data course methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color  = UIColor.init(hexString: selectedCategory?.colour).darken(byPercentage: (CGFloat(indexPath.row) / CGFloat((toDoItems?.count)!))){
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
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
                        newItem.dateCreated = Date()
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
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error deleting item \(error)")
            }
        }
    }
    
}
// Mark: search bar methods
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     toDoItems = toDoItems?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
                loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
