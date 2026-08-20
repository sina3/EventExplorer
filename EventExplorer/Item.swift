//
//  Item.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
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
