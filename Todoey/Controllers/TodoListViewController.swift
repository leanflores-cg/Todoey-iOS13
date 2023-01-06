//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    
    var dataManager = DataManager()
    var category: Category? {
        didSet {
            if let c = category {
                loadItems()
                self.title = c.name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let task = self.dataManager.getItem(at: indexPath.row) {
            cell.textLabel?.text = task.name
            cell.accessoryType = task.isDone ? .checkmark : UITableViewCell.AccessoryType.none
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.todoListCount
    }
    
    
    // MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = self.dataManager.getItem(at: indexPath.row) {
            self.dataManager.save {
                item.isDone = !item.isDone
            }

        }
        self.reloadTable()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - SwipeTableViewController
    override func delete(at index: Int) {
        self.dataManager.delete(itemAt: index)
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

