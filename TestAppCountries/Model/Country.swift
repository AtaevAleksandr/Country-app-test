//
//  Country.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 05.12.2024.
//

import Foundation

// MARK: - Country
struct Country: Codable {
    let name: Name
    let flags: Flags
    let region: Region
    let capital: [String]?
    let population: Int
    let area: Double
    let currencies: [String: Currency]?
    let languages: [String: String]?
    let timezones: [String]
    let latlng: [Double]
    let maps: Maps?
    let translations: [String: Translation]

    var localizedOfficialName: String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"

        if let translation = translations[languageCode + "s"]?.official {
            return translation
        }

        return name.official
    }

    var localizedCommonName: String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"

        if let translation = translations[languageCode + "s"]?.common {
            return translation
        }

        return name.common
    }
}

// MARK: - Maps
struct Maps: Codable {
    let googleMaps, openStreetMaps: String
}

// MARK: - Name
struct Name: Codable {
    let official, common: String
}

// MARK: - Flags
struct Flags: Codable {
    let svg, png: String
}

// MARK: - Currency
struct Currency: Codable {
    let name, symbol: String
}

// MARK: - Translation
struct Translation: Codable {
    let official, common: String
}

// MARK: - Region
enum Region: String, Codable {
    case africa = "Africa"
    case americas = "Americas"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
}

