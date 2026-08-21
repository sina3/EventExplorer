//
//  EventsAPIClient.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation

struct EventsAPIClient: EventsServiceProtocol {
    let baseURL: URL
    let session: URLSession

    init(baseURL: URL = URL(string: "http://localhost:3001")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchEvents() async throws -> [Event] {
        let url = baseURL.appendingPathComponent("events")
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw EventsError.offline
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw EventsError.badResponse(statusCode: statusCode)
        }

        do {
            return try JSONDecoder.eventsDecoder.decode([Event].self, from: data)
        } catch {
            throw EventsError.decoding(error)
        }
    }
}

