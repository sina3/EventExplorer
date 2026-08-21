//
//  BookmarkEntity.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation
import SwiftData

@Model
final class BookmarkEntity {
    @Attribute(.unique) var eventId: String

    init(eventId: String) {
        self.eventId = eventId
    }
}

