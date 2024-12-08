//
//  CountryDetailView.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 06.12.2024.
//

import SwiftUI
import CoreLocation

struct CountryDetailView: View {

    let country: Country
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var countriesViewModel: CountriesViewModel

    @State private var isFavorite = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Карта страны
                map

                // Флаг страны
                flag

                VStack(alignment: .leading) {
                    // Название страны и добавление в избранное
                    nameAndFavoriteButton

                    Divider().padding(.bottom, 10)

                    // Регион
                    region

                    // Столица
                    capital

                    // Население
                    population

                    // Площадь
                    area

                    // Валюта
                    currency

                    // Языки
                    languages

                    // Часовые пояса
                    timeZones
                }
                .padding()
            }
        }
        .onAppear {
            isFavorite = countriesViewModel.isFavorite(country)
        }
        .navigationTitle(country.localizedCommonName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { shareButton }
    }

    //MARK: - Components
    private var map: some View {
        MapView(coordinate: CLLocationCoordinate2D(
            latitude: country.latlng[0],
            longitude: country.latlng[1])
        )
        .ignoresSafeArea()
        .frame(height: 300)
    }

    private var flag: some View {
        ZStack {
            if let flagURL = URL(string: country.flags.svg) {
                CircleImage(svgURL: flagURL)
                    .offset(y: -130)
                    .padding(.bottom, -130)
            }
        }
    }

    private var nameAndFavoriteButton: some View {
        HStack(alignment: .center, spacing: 15) {
            Text(country.localizedOfficialName)
                .font(.largeTitle)
                .bold()

            FavoriteButton(isSet: $isFavorite)
                .onChange(of: isFavorite) { oldValue, newValue in
                    if newValue {
                        countriesViewModel.addFavorite(country, modelContext: modelContext)
                    } else {
                        countriesViewModel.removeFavorite(country, modelContext: modelContext)
                    }
                }
        }
        .padding(.bottom, 10)
    }

    private var region: some View {
        HStack {
            Text("Region: ")
                .font(.headline)
            +
            Text("\(country.region.rawValue)")
        }
        .padding(.bottom, 10)
    }

    private var capital: some View {
        ZStack {
            if let capital = country.capital?.first {
                HStack {
                    Text("Capital: ")
                        .font(.headline)
                    +
                    Text("\(capital)")
                }
            } else {
                HStack {
                    Text("Capital: ")
                        .font(.headline)
                    +
                    Text("Unknown")
                }
            }
        }
        .padding(.bottom, 10)
    }

    private var population: some View {
        HStack {
            Text("Population: ")
                .font(.headline)
            +
            Text("\(country.population.formatted())")
        }
        .padding(.bottom, 10)
    }

    private var area: some View {
        HStack {
            Text("Area: ")
                .font(.headline)
            +
            Text("\(String(format: "%.2f", country.area)) km²")
        }
        .padding(.bottom, 10)
    }

    private var currency: some View {
        ZStack {
            if let currency = country.currencies?.first?.value {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Currency:")
                        .font(.headline)
                    HStack {
                        Text("Name: \(currency.name)")
                    }
                    HStack {
                        Text("Symbol: \(currency.symbol)")
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }

    private var languages: some View {
        ZStack {
            if let languages = country.languages {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Languages:")
                        .font(.headline)
                    ForEach(languages.keys.sorted(), id: \.self) { key in
                        Text("\(languages[key] ?? "Unknown")")
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }

    private var timeZones: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Timezones:")
                .font(.headline)
            ForEach(country.timezones, id: \.self) { timezone in
                Text(timezone)
            }
        }
        .padding(.bottom, 10)
    }

    private var shareButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            ShareLink(item: country.maps?.googleMaps ?? "Not found")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.headline)
        }
    }
}

#Preview {
    ListCountriesView()
        .environmentObject(CountriesViewModel())
}
