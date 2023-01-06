//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lean Flores on 1/2/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework

let defaultBgColor = UIColor(hexString: "1D9BF6")

class CategoryViewController: SwipeTableViewController {

    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = defaultBgColor
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor : ContrastColorOf(defaultBgColor! , returnFlat: true)]
    }

    // MARK: - IBAction
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        var todoCategoryTextField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            guard let category = todoCategoryTextField.text, category != "" else { return }
            
            self.dataManager.addCategory(category)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Add new Category"
            todoCategoryTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    // MARK: - tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.categoriesCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = "No Categories added yet"
        if let category = dataManager.getCategory(at: indexPath.row) {
            cell.textLabel?.text = category.name
            cell.accessoryType = .disclosureIndicator
            
            if let bgColor = UIColor(hexString: (category.backgroundColorHex)) {
                cell.backgroundColor = bgColor
                cell.textLabel?.textColor = ContrastColorOf(bgColor , returnFlat: true)
            }
            
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.itemsSegueIdentifier, sender: self)
        
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.itemsSegueIdentifier {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.category = dataManager.getCategory(at: indexPath.row)
            }
        }
    }
    
    
    // MARK: - helpers
    func loadCategories() {
        dataManager.loadCategories()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - SwipeTableViewController
    override func delete(at indexPath: IndexPath) {
        self.dataManager.delete(categoryAt: indexPath.row)
    }
}
