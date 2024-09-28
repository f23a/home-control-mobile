//
//  Environment.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 28.09.24.
//

import Foundation

enum Environment {
    private static var cachedFileContent: [String: Any]?
    private static var fileContent: [String: Any] {
        if let cachedFileContent {
            return cachedFileContent
        }

        guard let url = Bundle.main.url(forResource: ".env", withExtension: "json") else {
            fatalError("Failed to get .env.json url")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load .env.json content")
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            fatalError("Failed to parse .env.json data")
        }

        cachedFileContent = jsonObject
        return jsonObject
    }

    static func get(_ key: String) -> String? {
        return fileContent[key] as? String
    }

    static func require(_ key: String) -> String {
        guard let value = get(key) else { fatalError("Failed to get environment variable \(key)") }
        return value
    }
}
