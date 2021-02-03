//
//  Outfit.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/18/20.
//

import Foundation
import RealmSwift


class Outfit: Object {
    @objc dynamic var name: String = ""
    var items = RealmSwift.List<ClosetItem>()
}
