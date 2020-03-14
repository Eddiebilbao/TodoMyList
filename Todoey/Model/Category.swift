//
//  Category.swift
//  Todoey
//
//  Created by User on 14/03/2020.
//  Copyright © 2020 naderkaabi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
