//
//  ContentView.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let client = EventsAPIClient()
    @State var events: [Event]? = []

    var body: some View {
        List {
            if let events {
                ForEach(events) { event in
                    Text(event.title)
                }
            }
        }
        .task {
            events = try? await client.fetchEvents()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ BookmarkEntity.self], inMemory: true)
}
