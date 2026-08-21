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
    private(set) var bookmarkedIds: Set<String> = []

    private let service: EventsServiceProtocol
    private let store: PersistenceStore

    init(service: EventsServiceProtocol, store: PersistenceStore) {
        self.service = service
        self.store = store
    }

    func load() async {
        state = .loading
        refreshBookmarks()
        do {
            let events = try await service.fetchEvents()
            state = .loaded(events)
        } catch {
            state = .failed(error)
        }
    }

    func refreshBookmarks() {
        bookmarkedIds = store.bookmarkedIds()
    }
}

