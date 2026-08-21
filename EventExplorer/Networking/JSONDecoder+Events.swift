//
//  JSONDecoder+Events.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation

extension JSONDecoder {
    static var eventsDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

