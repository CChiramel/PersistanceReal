//
//  Item.swift
//  PersistanceReal
//
//  Created by Chris K. Chiramel on 9/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
