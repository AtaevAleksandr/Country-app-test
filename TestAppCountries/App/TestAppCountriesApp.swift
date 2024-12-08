//
//  TestAppCountriesApp.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 05.12.2024.
//

import SwiftUI

@main
struct TestAppCountriesApp: App {

    @StateObject private var countriesViewModel = CountriesViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: [FavoriteCountry.self])
                .environmentObject(countriesViewModel)
        }
    }
}
