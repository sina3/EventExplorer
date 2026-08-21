//
//  EventDetailView.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import SwiftUI
import SwiftData

struct EventDetailView: View {
    let event: Event
    private let store: PersistenceStore
    @ObservedObject private var locationProvider: LocationProvider

    @State private var isBookmarked: Bool

    init(event: Event, store: PersistenceStore, locationProvider: LocationProvider) {
        self.event = event
        self.store = store
        self.locationProvider = locationProvider
        _isBookmarked = State(initialValue: store.isBookmarked(eventId: event.id))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                CachedAsyncImage(url: event.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.secondary.opacity(0.2)
                }
                .frame(height: 200)
                .clipped()

                Text(event.title)
                    .font(.title2)
                    .bold()

                Text(event.location.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(event.startTime.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let distance = Distance.distanceString(from: locationProvider.currentLocation, to: event.location) {
                    Text(distance)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    store.toggleBookmark(eventId: event.id)
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: BookmarkEntity.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    NavigationStack {
        EventDetailView(
            event: Event(
                id: "1",
                title: "Sample Event",
                location: EventLocation(lat: 43.6532, lng: -79.3832, address: "123 Main St, Toronto"),
                startTime: .now,
                imageURL: URL(string: "https://example.com/image.jpg")!
            ),
            store: PersistenceStore(modelContainer: container),
            locationProvider: LocationProvider()
        )
    }
}
