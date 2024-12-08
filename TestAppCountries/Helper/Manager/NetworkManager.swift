//
//  NetworkManager.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 05.12.2024.
//

import Foundation

enum Link {
    case countries

    var url: URL? {
        switch self {
        case .countries:
            URL(string: ConfigKeys.countriesUrl)
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case noInternetConnection
    case decodingError
    case badResponse
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            "Please check your internet connection and try again."
        case .decodingError:
            "There was error decoding."
        case .badResponse:
            "There was error bad response server. Please try again!"
        case .unknownError(let description):
            description
        }
    }
}

final class NetworkManager {
    // Обработка ответа с детализированными ошибками
    func handleResponse(data: Data?, response: URLResponse?) -> Data? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return data
    }

    // Асинхронный запрос для получения стран
    func getCountriesData() async throws -> [Country] {
        guard let url = Link.countries.url else {
            throw NetworkError.decodingError
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let validData = handleResponse(data: data, response: response) else {
                throw NetworkError.badResponse
            }
            do {
                return try JSONDecoder().decode([Country].self, from: validData)
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            if (error as? URLError) != nil {
                throw NetworkError.noInternetConnection
            } else {
                throw NetworkError.unknownError(error.localizedDescription)
            }
        }
    }
}

