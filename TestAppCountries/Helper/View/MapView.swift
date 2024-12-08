//
//  MapView.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 06.12.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(position: .constant(.region(region)))
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 2,
                longitudeDelta: 2)
        )
    }
}

#Preview {
    MapView(coordinate: CLLocationCoordinate2D(
        latitude: 60.0,
        longitude: 100.0))
}
