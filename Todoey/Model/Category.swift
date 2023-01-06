//
//  Category.swift
//  Todoey
//
//  Created by Lean Flores on 1/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var createdDate: Date?
    @objc dynamic var backgroundColorHex: String = ""
    let items = List<Item>()
}
