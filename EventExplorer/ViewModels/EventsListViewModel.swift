//
//  EventsListViewModel.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation
import Observation

@Observable
final class EventsListViewModel {
    enum State {
        case idle
        case loading
        case loaded([Event])
        case failed(Error)
    }

    private(set) var state: State = .idle

    private let service: EventsServiceProtocol

    init(service: EventsServiceProtocol) {
        self.service = service
    }

    func load() async {
        state = .loading
        do {
            let events = try await service.fetchEvents()
            state = .loaded(events)
        } catch {
            state = .failed(error)
        }
    }
}

