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
    @StateObject private var locationProvider: LocationProvider

    init(vm: EventsListViewModel, store: PersistenceStore, locationProvider: LocationProvider = LocationProvider()) {
        _vm = State(initialValue: vm)
        self.store = store
        _locationProvider = StateObject(wrappedValue: locationProvider)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if vm.isOffline {
                    offlineBanner
                }
                content
            }
            .navigationTitle("Events")
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
        .task { await vm.load() }
        .onAppear { locationProvider.requestPermission() }
    }

    private var offlineBanner: some View {
        Text("You're offline")
            .font(.subheadline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 25)
            .padding(.vertical, 6)
            .background(Color.red, ignoresSafeAreaEdges: [])
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
                    EventDetailView(event: event, store: store, locationProvider: locationProvider)
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
                if let distance = Distance.distanceString(from: locationProvider.currentLocation, to: event.location) {
                    Text(distance)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
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
