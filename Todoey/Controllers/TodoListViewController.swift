//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var dataManager = DataManager()
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        self.title = category?.name ?? "Todoey"
    }
    
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath)
        let task = self.dataManager.todoList[indexPath.row]
        cell.textLabel?.text = task.name
        cell.accessoryType = task.isDone ? .checkmark : UITableViewCell.AccessoryType.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.todoList.count
    }
    
    
    // MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // delete
        // self.dataManager.delete(itemAt: indexPath.row)
        
        // update
        let item = self.dataManager.todoList[indexPath.row]
        item.isDone = !item.isDone
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // save
        self.saveAndReload()
        
    }
    
    // MARK: - IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        var todoItemTextField = UITextField()
        
        alert.addTextField { textField in
            textField.placeholder = "Create new item"
            todoItemTextField = textField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            guard let todoItem = todoItemTextField.text, todoItem != "" else { return }
            
            self.dataManager.addItem(todoItem, for: self.category!)
            self.reloadTable()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    // MARK: - helpers
    func loadItems(searchText: String? = nil) {
        dataManager.loadItems(with: searchText, for: category!)
        self.reloadTable()
    }
    func saveAndReload() {
        self.dataManager.save()
        self.reloadTable()
    }
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        loadItems(searchText: searchBar.text!)
        dismissKeyboard(searchBar)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            dismissKeyboard(searchBar)
        }
    }
    
    func dismissKeyboard(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

