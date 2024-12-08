//
//  HomeView.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 05.12.2024.
//

import SwiftUI

struct HomeView: View {

    @State private var selectionTab: Tab = .list

    enum Tab {
        case list
        case favorites
    }

    var body: some View {
        TabView(selection: $selectionTab) {
            ListCountriesView()
                .tabItem { Label("List", systemImage: "list.bullet") }
                .tag(Tab.list)

            FavoritesList()
                .tabItem { Label("Favorites", systemImage: "star") }
                .tag(Tab.favorites)
        }
    }
}
