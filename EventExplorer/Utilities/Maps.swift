//
//  Maps.swift
//  EventExplorer
//
//  Created by Sina Rezazadeh on 2026-08-21.
//

import MapKit

enum Maps {
    static func openInMaps(_ location: EventLocation, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        mapItem.openInMaps()
    }
}
