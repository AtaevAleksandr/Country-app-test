//
//  FavoriteCountry.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 07.12.2024.
//

import Foundation
import SwiftData

@Model
final class FavoriteCountry {
    @Attribute(.unique) var id: String
    var name: String
    var region: Region
    var flags: Flags
    var latlng: [Double]
    var capital: [String]?
    var population: Int
    var area: Double
    var currencies: [String: Currency]?
    var languages: [String: String]?
    var timezones: [String]
    var maps: Maps?
    var translations: [String: Translation]

    init(
        id: String,
        name: String,
        region: Region,
        flags: Flags,
        latlng: [Double],
        capital: [String]?,
        population: Int,
        area: Double,
        currencies: [String: Currency]?,
        languages: [String: String]?,
        timezones: [String],
        maps: Maps?,
        translations: [String: Translation]
    ) {
        self.id = id
        self.name = name
        self.region = region
        self.flags = flags
        self.latlng = latlng
        self.capital = capital
        self.population = population
        self.area = area
        self.currencies = currencies
        self.languages = languages
        self.timezones = timezones
        self.maps = maps
        self.translations = translations
    }
}
