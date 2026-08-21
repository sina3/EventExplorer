//
//  EventsListViewModelTests.swift
//  EventExplorerTests
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation
import Testing
import SwiftData
@testable import EventExplorer

@MainActor
struct EventsListViewModelTests {
    private func makeStore() -> PersistenceStore {
        let container = try! ModelContainer(
            for: BookmarkEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return PersistenceStore(modelContainer: container)
    }

    private let sampleEvent = Event(
        id: "evt-001",
        title: "Waterfront Night Market",
        location: EventLocation(lat: 43.6385, lng: -79.3816, address: "Queens Quay, Toronto"),
        startTime: .now,
        imageURL: URL(string: "https://picsum.photos/seed/evt-001/600/400")!
    )

    @Test func loadSucceedsWithEvents() async {
        let vm = EventsListViewModel(service: MockEventsService(result: .success([sampleEvent])), store: makeStore())

        await vm.load()

        guard case .loaded(let events) = vm.state else {
            Issue.record("Expected .loaded state")
            return
        }
        #expect(events == [sampleEvent])
    }

    @Test func loadFailsWhenServiceThrows() async {
        struct SampleError: Error {}
        let vm = EventsListViewModel(service: MockEventsService(result: .failure(SampleError())), store: makeStore())

        await vm.load()

        guard case .failed = vm.state else {
            Issue.record("Expected .failed state")
            return
        }
    }

    @Test func refreshBookmarksReadsFromStore() async {
        let store = makeStore()
        store.toggleBookmark(eventId: sampleEvent.id)
        let vm = EventsListViewModel(service: MockEventsService(result: .success([sampleEvent])), store: store)

        await vm.load()

        #expect(vm.bookmarkedIds == [sampleEvent.id])
    }
}
