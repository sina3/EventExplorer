//
//  PersistenceStore.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation
import SwiftData

// This class creates its own ModelContext instead of reading it from @Environment,
// so we can make one and test it without needing a SwiftUI view.
@MainActor
final class PersistenceStore {
    private let modelContext: ModelContext

    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }

    func toggleBookmark(eventId: String) {
        let descriptor = FetchDescriptor<BookmarkEntity>(
            predicate: #Predicate { $0.eventId == eventId }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
        } else {
            modelContext.insert(BookmarkEntity(eventId: eventId))
        }
        try? modelContext.save()
    }

    func isBookmarked(eventId: String) -> Bool {
        let descriptor = FetchDescriptor<BookmarkEntity>(
            predicate: #Predicate { $0.eventId == eventId }
        )
        return ((try? modelContext.fetch(descriptor).first) ?? nil) != nil
    }

    func bookmarkedIds() -> Set<String> {
        let entities = (try? modelContext.fetch(FetchDescriptor<BookmarkEntity>())) ?? []
        return Set(entities.map(\.eventId))
    }
}

