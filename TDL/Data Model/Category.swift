//
//  Category.swift
//  TDL
//
//  Created by Nauman Bajwa on 1/5/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
