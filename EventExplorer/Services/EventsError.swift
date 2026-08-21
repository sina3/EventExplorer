//
//  EventsError.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import Foundation

enum EventsError: Error {
    case badResponse(statusCode: Int)
    case decoding(Error)
    case offline
}

