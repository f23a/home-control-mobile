//
//  AppState.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 26.10.24.
//

import HomeControlClient
import HomeControlKit
import HomeControlLogging
import Logging
import SwiftUI

@MainActor
@Observable class AppState {
    private let logger = Logger(homeControl: "mobile.app-state")

    private(set) var endpoint: Endpoint
    var homeControlClient: HomeControlClientable
    private var homeControlWebSocket: HomeControlWebSocket?

    var latestInverterReading: Stored<InverterReading>?

    init() {
        LoggingSystem.bootstrapHomeControl()

        endpoint = Settings.endpoint ?? .production
        homeControlClient = HomeControlClient.production

        updateHomeControlClientCatch()
    }

    func changeEndpoint(to endpoint: Endpoint) {
        self.endpoint = endpoint
        Settings.endpoint = endpoint
        Settings.synchronize()

        updateHomeControlClientCatch()
    }

    private func updateHomeControlClientCatch() {
        do {
            try updateHomeControlClient()
        } catch {
            logger.critical("Failed to update home control client: \(error)")
        }
    }

    private func updateHomeControlClient() throws {
        switch endpoint {
        case .localIPAddressMacMini:
            let ip = try DotEnv.fromMainBundle().require("MAC_MINI_IP")
            guard var client = HomeControlClient(host: ip, port: 8080) else { throw Error.failedToInitClient }
            client.authToken = try DotEnv.fromMainBundle().require("PROD_AUTH_TOKEN")
            homeControlClient = client
        case .localIPAddressMacBook:
            let ip = try DotEnv.fromMainBundle().require("MAC_BOOK_IP")
            guard var client = HomeControlClient(host: ip, port: 8080) else { throw Error.failedToInitClient }
            client.authToken = try DotEnv.fromMainBundle().require("DEV_AUTH_TOKEN")
            homeControlClient = client
        case .production:
            var client = HomeControlClient.production
            client.authToken = try DotEnv.fromMainBundle().require("PROD_AUTH_TOKEN")
            homeControlClient = client
        }
        logger.info("Updated Home Control Client to \(homeControlClient.addressDisplayName)")

        homeControlWebSocket?.close()
        homeControlWebSocket = .init(client: homeControlClient, delegate: self)
    }

    enum Error: Swift.Error {
        case failedToInitClient
    }
}

extension AppState: @preconcurrency HomeControlWebSocketDelegate {
    func homeControlWebSocket(
        _ homeControlWebSocket: HomeControlWebSocket,
        didCreateInverterReading inverterReading: Stored<InverterReading>
    ) {
        latestInverterReading = inverterReading
        logger.info("Latest inverter reading \(latestInverterReading?.id.uuidString ?? "")")
    }

    func homeControlWebSocket(
        _ homeControlWebSocket: HomeControlWebSocket,
        didSaveSetting setting: HomeControlKit.Setting
    ) {

    }
}
