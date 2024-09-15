//
//  Item.swift
//  Todoey
//
//  Created by Lean Flores on 1/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var createdDate: Date?
    var category = LinkingObjects(fromType: Category.self, property: "items")
}
