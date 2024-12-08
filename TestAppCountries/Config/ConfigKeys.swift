//
//  ConfigKeys.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 09.12.2024.
//

import Foundation

public enum ConfigKeys {
    enum Keys {
        static let countriesUrl = "COUNTRIES_URL"
        static let cacheKey = "CACHE_KEY"
        static let diskCache = "DISK_CACHE"
        static let subdirectoryCache = "SUBDIRECTORY_CACHE"
    }

    // Получаем plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError()
        }
        return dict
    }()

    // Получаем url из plist
    static let countriesUrl: String = {
        guard let url = ConfigKeys.infoDictionary[Keys.countriesUrl] as? String else {
            fatalError("Url is not set in plist")
        }
        return url
    }()

    // Получаем кэш ключ
    static let cacheKey: String = {
        guard let key = ConfigKeys.infoDictionary[Keys.cacheKey] as? String else {
            fatalError("Cache key is not set in plist")
        }
        return key
    }()

    // Получаем диск кэш
    static let diskCache: String = {
        guard let disk = ConfigKeys.infoDictionary[Keys.diskCache] as? String else {
            fatalError("Disk cache is not set in plist")
        }
        return disk
    }()

    // Получаем subdirectory кэш
    static let subdirectoryCache: String = {
        guard let sub = ConfigKeys.infoDictionary[Keys.subdirectoryCache] as? String else {
            fatalError("Subdirectory cache is not set in plist")
        }
        return sub
    }()
}
