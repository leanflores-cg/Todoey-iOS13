//
//  DataManager.swift
//  Todoey
//
//  Created by Lean Flores on 12/30/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    var todoList: [Item] = [Item]()
    var categories: [Category] = [Category]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        appDelegate.saveContext()
    }
    
    func fetch(categoryRequest: NSFetchRequest<Category>? = nil, itemRequest: NSFetchRequest<Item>? = nil) -> [NSManagedObject]? {
        do {
            if categoryRequest != nil {
                return try context.fetch(categoryRequest!)
            } else if itemRequest != nil {
                return try context.fetch(itemRequest!)
            } else {
                return [NSManagedObject]()
            }
        } catch {
            print("Fetch error \(error)")
            return [NSManagedObject]()
        }
    }
}


// MARK: - Item
extension DataManager {
    func loadItems(with searchText: String?, for category: Category) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let basePredicate = "category == %@"
        
        if let safeSearchText = searchText, safeSearchText != "" {
            request.predicate = NSPredicate(format: "\(basePredicate) AND name CONTAINS[cd] %@", category, safeSearchText)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        } else {
            request.predicate = NSPredicate(format: basePredicate, category)
        }
        
        do {
            todoList = try context.fetch(request)
        } catch {
            print("Fetch error \(error)")
        }
    }
    func addItem(_ name: String, for category: Category) {
        let newItem = Item(context: context)
        newItem.name = name
        newItem.isDone = false
        newItem.category = category
        self.todoList.append(newItem)
        save()
    }
    func delete(itemAt idx: Int) {
        let item = todoList[idx]
        context.delete(item)
        todoList.remove(at: idx)
    }
}


// MARK: - Category
extension DataManager {
    
    func loadCategories() {
        categories = fetch(categoryRequest: Category.fetchRequest()) as! [Category]
    }
    func addCategory(_ categoryName: String) {
        let newCategory = Category(context: context)
        newCategory.name = categoryName
        
        categories.append(newCategory)
        save()
    }
}
