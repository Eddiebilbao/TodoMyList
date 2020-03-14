//
//  CategoryViewController.swift
//  Todoey
//
//  Created by User on 13/03/2020.
//  Copyright © 2020 naderkaabi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

    
//MARK: - TableView Delegate Methods
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text =  categories[indexPath.row].name
        return cell
            
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            // context.delete(categories[indexPath.row])
            // categories.remove(at: indexPath.row)
            // loadCategories()
            
        performSegue(withIdentifier: "goToItems", sender: self)
          
    }
        
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
   }
    
//MARK: - Data Manipulation Methods
       
       
    func saveCategories(){

        do { try context.save()

              }
        catch {print("Error saving category \(error)")
        }
        tableView.reloadData()
    }


    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){

        do {
                categories = try context.fetch(request)
                  }
        catch {
                print("Error feching data from context  \(error)")
        }
        tableView.reloadData()
    }
          
//MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) {
            // what will happen once the user clicks the Add Item button on our UIAlert
            (action) in
                if textField.text! != "" {
                let category = Category(context: self.context)
                category.name = textField.text!
                self.categories.append(category)
                self.saveCategories()  // Saving category in Category.plist file on the dataFilePath
            }
        }
        
        alert.addTextField {
            (alertTextField) in
                alertTextField.placeholder = "Add a New Category"
                textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource Methods
    
    
    
    
    
   
    
    
    
   
       
}
