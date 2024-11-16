//
//  Settings.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 14.11.24.
//

import Foundation

enum Settings {
    static var endpoint: Endpoint? {
        get {
            UserDefaults.standard.string(forKey: "endpoint")
                .flatMap { .init(rawValue: $0) }
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: "endpoint")
        }
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
