//
//  DataManager.swift
//  Todoey
//
//  Created by Lean Flores on 12/30/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DataManager {
    
    private var todoList: Results<Item>?
    private var categories: Results<Category>?
    
    var categoriesCount: Int {
        return categories?.count ?? 1
    }
    
    var todoListCount: Int {
        return todoList?.count ?? 1
    }
    
    func getCategory(at index: Int) -> Category? {
        return categories?[index]
    }
    
    func getItem(at index: Int) -> Item? {
        return todoList?[index]
    }
    
    // RealmSwift
    let realm = try! Realm()
    
    
    func save(_ callback: () -> Void) {
        do {
            try realm.write {
                callback()
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}


// MARK: - Item
extension DataManager {
    func loadItems(with searchText: String?, for category: Category) {
        todoList = category
            .items
            .sorted(byKeyPath: "createdDate", ascending: true)
        if let safeSearchText = searchText {
            todoList = todoList?.filter("name CONTAINS[cd] %@", safeSearchText)
        }
    }
    
    func addItem(_ name: String, for category: Category) {
        let newItem = Item()
        newItem.name = name
        newItem.isDone = false
        newItem.createdDate = Date()
        save {
            category.items.append(newItem)
            realm.add(newItem)
        }
    }
    func delete(itemAt idx: Int) {
        if let item = getItem(at: idx) {
            save {
                realm.delete(item)
            }
        }
        
    }
}


// MARK: - Category
extension DataManager {
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func addCategory(_ categoryName: String) {
        let newCategory = Category()
        newCategory.name = categoryName
        newCategory.createdDate = Date()
        save {
            realm.add(newCategory)
        }
    }
}
