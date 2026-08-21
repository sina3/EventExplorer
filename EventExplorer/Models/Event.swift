//
//  Event.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let location: EventLocation
    let startTime: Date
    let imageURL: URL
}
