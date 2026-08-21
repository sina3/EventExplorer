//
//  EventListView.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import SwiftUI

struct EventListView: View {
    @State private var vm: EventsListViewModel

    init(vm: EventsListViewModel = EventsListViewModel(service: EventsAPIClient())) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        content
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
            }
        }
    }
}

#Preview {
    EventListView(vm: EventsListViewModel(service: MockEventsService()))
}
