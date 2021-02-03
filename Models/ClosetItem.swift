//
//  ClosetItem.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/18/20.
//

import Foundation
import UIKit
import RealmSwift

class ClosetItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var image: Data?
    @objc dynamic var type: String = ""
    var color: UIColor?
    @objc dynamic var formal: Bool = false
    
    // change to conform to codable
    // might need a custom init
}



