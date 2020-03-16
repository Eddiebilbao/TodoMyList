//
//  ViewController.swift
//  Todoey
//
//  Created by User on 07/03/2020.
//  Copyright © 2020 naderkaabi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    var selectedItemPath : IndexPath?
    
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    //MARK - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item added yet"
        }
        return cell
    }
   
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done =  !item.done
                    self.selectedItemPath = indexPath
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            // what will happen once the user clicks the Add Item button on our UIAlert
            (action) in
            if textField.text! !=  "" {
            if let currentCategory = self.selectedCategory {
                do {
                    
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        print(newItem.dateCreated!)
                        currentCategory.items.append(newItem)
                    }
                    } catch {
                        print("Error saving newItem \(error)")
                    }
            }
            self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField {
            (alertTextField) in
                alertTextField.placeholder = "Create New Item"
                textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
   
    
    
    @IBAction func deleteItemPressed(_ sender: UIBarButtonItem) {
        
        if let indexPath = selectedItemPath {
                if  let  item = toDoItems?[indexPath.row] {
                        print("delete item: \(item.title)")
                        if item.done == true {
                            deleteItem(item: item)
                        }
                    
                } else{
                        print("Error no more item to delete")
                }
            } 
        
    }
        
    
        

    
    
    
//MARK: - Model Manipulation Methods
    
//    func saveItems(item: Item){
//
//        do {
//            try realm.write {
//                realm.add(item)
//
//                }
//        } catch {
//                print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//    }
//
   
        //loading Items
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
     }
    
   
    func deleteItem(item: Item) {
       // for item in selectedArray.map(deleteItem(item: item))
            do {
                try realm.write {
                    realm.delete(item)

                }
            } catch {
                print("Error deleting item, \(error)")
            }
        tableView.reloadData()
    }
     
   
}



//MARK: - Searchbar Delegate Method

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // dissmiss keyboard
            }

        }

    }





}

