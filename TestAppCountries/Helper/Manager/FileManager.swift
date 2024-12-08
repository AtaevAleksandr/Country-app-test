//
//  FileManager.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 07.12.2024.
//

import SwiftUI

final class DiskCache {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init(subdirectory: String = ConfigKeys.diskCache) {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cacheDir.appendingPathComponent(subdirectory)

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    // Сохраняем
    func saveImage(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
    }

    // Загружаем
    func loadImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}

private extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.map { String(format: "%02hhx", $0) }.joined()
        return hash
    }
}

extension DiskCache {
    func saveJSON<T: Encodable>(_ object: T, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save JSON to disk: \(error.localizedDescription)")
        }
    }

    func loadJSON<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        do {
            let data = try Data(contentsOf: fileURL)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            return nil
        }
    }
}

