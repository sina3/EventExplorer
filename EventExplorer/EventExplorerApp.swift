//
//  EventExplorerApp.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import SwiftUI
import SwiftData

@main
struct EventExplorerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BookmarkEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            EventListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
