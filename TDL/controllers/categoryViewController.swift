//
//  categoryViewController.swift
//  TDL
//
//  Created by Nauman Bajwa on 1/5/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class categoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    //Mark: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        guard let categoryColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D98F6") else {
            fatalError()
        }
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
        cell.backgroundColor = categoryColor
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (performSegue(withIdentifier: "goToItems", sender: self))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func save(category: Category){
        do {
            try realm.write{
                realm.add(category)
            }
        }catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
   func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //Mark:- delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting item \(error)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat()?.hexValue() ?? "1D98F6"
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
            
        }
        present(alert, animated: true, completion: nil)
    }
    
}
