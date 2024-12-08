//
//  CountriesViewModel.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 06.12.2024.
//

import SwiftUI
import SwiftData

final class CountriesViewModel: ObservableObject {
    private let diskCache = DiskCache(subdirectory: ConfigKeys.subdirectoryCache)
    private let cacheKey = ConfigKeys.cacheKey
    let networkManager = NetworkManager()

    @Published var countries = [Country]()
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var favoriteCountries = [Country]()
    @Published var networkError: NetworkError?

    var isDataLoaded: Bool = false

    var filteredCountries: [Country] {
        guard !searchText.isEmpty else { return countries }
        return countries.filter { $0.localizedOfficialName.localizedCaseInsensitiveContains(searchText) }
    }

    // Ловим данные
    @MainActor
    func fetchCountries() async {
        guard !isDataLoaded else { return }

        isLoading = true
        defer { isLoading = false }

        // Сначала загружаем из кэша
        if let cachedCountries: [Country] = diskCache.loadJSON(forKey: cacheKey, as: [Country].self) {
            self.countries = cachedCountries
            isDataLoaded = true
            return
        }

        // Если данных в кэше нет, загружаем из API
        do {
            let fetchedCountries = try await networkManager.getCountriesData()
            self.countries = fetchedCountries
            isDataLoaded = true

            // Сохраняем данные в кэш
            diskCache.saveJSON(fetchedCountries, forKey: cacheKey)
        } catch let error as NetworkError {
            self.networkError = error
        } catch {
            self.networkError = .noInternetConnection
        }
    }

    // Добавляем в избранное
    func addFavorite(_ country: Country, modelContext: ModelContext) {
        guard !isFavorite(country) else { return }

        // Сохраняем в базу данных
        let favorite = FavoriteCountry(
            id: country.name.official,
            name: country.name.common,
            region: country.region,
            flags: country.flags,
            latlng: country.latlng,
            capital: country.capital,
            population: country.population,
            area: country.area,
            currencies: country.currencies,
            languages: country.languages,
            timezones: country.timezones,
            maps: country.maps,
            translations: country.translations
        )
        modelContext.insert(favorite)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save favorite: \(error.localizedDescription)")
        }

        // Обновляем массив
        favoriteCountries.append(country)
    }

    // Удаляем из избранного
    func removeFavorite(_ country: Country, modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<FavoriteCountry>(
            predicate: #Predicate { $0.id == country.name.official }
        )

        if let favorite = try? modelContext.fetch(fetchDescriptor).first {
            // Удаляем из базы данных
            modelContext.delete(favorite)
            do {
                try modelContext.save()
            } catch {
                print("Failed to delete favorite: \(error.localizedDescription)")
            }
        }

        // Обновляем массив
        if let index = favoriteCountries.firstIndex(where: { $0.name.official == country.name.official }) {
            favoriteCountries.remove(at: index)
        }
    }

    func isFavorite(_ country: Country) -> Bool {
        favoriteCountries.contains(where: { $0.name.official == country.name.official })
    }

    // Загружаем избранные страны из базы данных
    func loadFavorites(modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<FavoriteCountry>()
        if let favorites = try? modelContext.fetch(fetchDescriptor) {
            self.favoriteCountries = favorites.map {
                Country(
                    name: Name(official: $0.id, common: $0.name),
                    flags: $0.flags,
                    region: $0.region,
                    capital: $0.capital,
                    population: $0.population,
                    area: $0.area,
                    currencies: $0.currencies,
                    languages: $0.languages,
                    timezones: $0.timezones,
                    latlng: $0.latlng,
                    maps: $0.maps,
                    translations: $0.translations
                )
            }
        }
    }
}
