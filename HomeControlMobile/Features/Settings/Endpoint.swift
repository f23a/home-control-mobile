//
//  Endpoint.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 14.11.24.
//

enum Endpoint: String, Identifiable, CaseIterable {
    case localIPAddressMacMini
    case localIPAddressMacBook
    case production

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .localIPAddressMacMini: return "Local IP Address (Mac Mini)"
        case .localIPAddressMacBook: return "Local IP Address (MacBook)"
        case .production: return "Production"
        }
    }
}
