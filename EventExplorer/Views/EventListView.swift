//
//  EventListView.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import SwiftUI
import SwiftData

struct EventListView: View {
    @State private var vm: EventsListViewModel
    private let store: PersistenceStore

    init(vm: EventsListViewModel, store: PersistenceStore) {
        _vm = State(initialValue: vm)
        self.store = store
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Events")
        }
        .task { await vm.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView()
        case .failed:
            VStack(spacing: 12) {
                Text("Something went wrong")
                    .foregroundStyle(.secondary)
                Button("Retry") {
                    Task { await vm.load() }
                }
            }
        case .loaded(let events):
            List(events) { event in
                NavigationLink {
                    EventDetailView(event: event, store: store)
                } label: {
                    row(for: event)
                }
            }
            .onAppear { vm.refreshBookmarks() }
        }
    }

    private func row(for event: Event) -> some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: event.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                Text(event.location.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(event.startTime.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if vm.bookmarkedIds.contains(event.id) {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.tint)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: BookmarkEntity.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let store = PersistenceStore(modelContainer: container)
    return EventListView(
        vm: EventsListViewModel(service: MockEventsService(), store: store),
        store: store
    )
}
