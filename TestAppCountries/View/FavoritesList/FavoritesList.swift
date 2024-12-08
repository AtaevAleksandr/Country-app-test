//
//  FavoritesList.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 07.12.2024.
//

import SwiftUI

struct FavoritesList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var countriesViewModel: CountriesViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(countriesViewModel.favoriteCountries, id: \.name.official) { country in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            EmptyView()
                        }
                        .opacity(.zero)

                        CountryRow(country: country)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            countriesViewModel.removeFavorite(country, modelContext: modelContext)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
            }
            .onAppear {
                countriesViewModel.loadFavorites(modelContext: modelContext)
            }
            .navigationTitle("Favorites")
            .listStyle(.plain)
        }
    }
}

#Preview {
    FavoritesList()
        .environmentObject(CountriesViewModel())
}
