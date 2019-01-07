//
//  Item.swift
//  TDL
//
//  Created by Nauman Bajwa on 1/5/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
