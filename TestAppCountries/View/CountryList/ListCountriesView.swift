//
//  ListCountriesView.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 05.12.2024.
//

import SwiftUI

struct ListCountriesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var countriesViewModel: CountriesViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(countriesViewModel.filteredCountries, id: \.name.official) { country in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            EmptyView()
                        }
                        .opacity(.zero)

                        CountryRow(country: country)

                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }

            }
            .navigationTitle("Countries")
            .listStyle(.plain)
            .searchable(text: $countriesViewModel.searchText, prompt: "Search Countries")
            .autocorrectionDisabled(true)
            .overlay(
                Group {
                    if countriesViewModel.isLoading {
                        ProgressView("Loading Countries...")
                    }
                }
            )
            .alert(item: $countriesViewModel.networkError) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.errorDescription ?? "An unexpected error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .task {
            await countriesViewModel.fetchCountries()
        }
        .onAppear {
            countriesViewModel.loadFavorites(modelContext: modelContext)
        }
    }
}

extension NetworkError: Identifiable {
    var id: String {
        self.errorDescription ?? "Unknown Error"
    }
}

#Preview {
    ListCountriesView()
        .environmentObject(CountriesViewModel())
}
