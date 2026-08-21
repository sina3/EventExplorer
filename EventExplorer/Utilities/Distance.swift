//
//  Distance.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-20.
//

import CoreLocation

enum Distance {
    static func meters(from userLocation: CLLocation, to eventLocation: EventLocation) -> CLLocationDistance {
        let destination = CLLocation(latitude: eventLocation.lat, longitude: eventLocation.lng)
        return userLocation.distance(from: destination)
    }

    static func distanceString(meters: CLLocationDistance) -> String {
        if meters < 1000 {
            return "\(Int(meters.rounded())) m"
        }
        return String(format: "%.1f km", meters / 1000)
    }

    static func distanceString(from userLocation: CLLocation?, to eventLocation: EventLocation) -> String? {
        guard let userLocation else { return nil }
        return distanceString(meters: meters(from: userLocation, to: eventLocation))
    }
}
