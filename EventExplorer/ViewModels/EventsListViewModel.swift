//
//  EventsListViewModel.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Combine
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
    private(set) var isOffline: Bool = false

    private let service: EventsServiceProtocol
    private let store: PersistenceStore
    private let networkMonitor: NetworkMonitor
    private var cancellables: Set<AnyCancellable> = []

    init(service: EventsServiceProtocol, store: PersistenceStore, networkMonitor: NetworkMonitor = NetworkMonitor()) {
        self.service = service
        self.store = store
        self.networkMonitor = networkMonitor

        networkMonitor.$isConnected
            .map { !$0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOffline in
                self?.isOffline = isOffline
            }
            .store(in: &cancellables)
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

