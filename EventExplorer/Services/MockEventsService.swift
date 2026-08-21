//
//  MockEventsService.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation

struct MockEventsService: EventsServiceProtocol {
    let result: Result<[Event], Error>

    init(result: Result<[Event], Error> = .success([])) {
        self.result = result
    }

    func fetchEvents() async throws -> [Event] {
        try result.get()
    }
}

