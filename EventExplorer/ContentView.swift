//
//  ContentView.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    let client = EventsAPIClient()
    @State var events: [Event]? = []
    
    var body: some View {
        List {
            if let events {
                ForEach(events) { event in
                    Text(event.title)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .task {
            events = try? await client.fetchEvents()
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
