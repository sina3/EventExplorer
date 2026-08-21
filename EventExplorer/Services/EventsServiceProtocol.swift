//
//  EventsServiceProtocol.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation

protocol EventsServiceProtocol {
    func fetchEvents() async throws -> [Event]
}

