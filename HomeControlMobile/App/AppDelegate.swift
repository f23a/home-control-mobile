//
//  AppDelegate.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 28.09.24.
//

import Foundation
import HomeControlClient
import HomeControlKit
import UIKit
import UserNotifications

@MainActor
class AppDelegate: NSObject {
    private(set) var appState = AppState()
    private(set) var homeControlClient: HomeControlClient
    private var homeControlWebSocket: HomeControlWebSocket

    override init() {
        let client = HomeControlClient.usingLocalIPAddress
        homeControlClient = client
        homeControlWebSocket = .init(client: client)
        super.init()

        homeControlWebSocket.delegate = self
    }

    private func requestRemoteNotificationsIfNeeded() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        requestRemoteNotificationsIfNeeded()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Did register for remote notifications \(tokenString)")
        Task.detached {
            do {
                try await self.homeControlClient.pushDevice.register(pushDevice: .init(deviceToken: tokenString))

                try await self.homeControlClient.pushDevice.updateSettings(
                    deviceToken: tokenString,
                    messageType: .adapterSungrowInverter,
                    settings: .init(isEnabled: true)
                )
            } catch {
                print("Failed to register device \(error)")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register")
    }
}

extension AppDelegate: @preconcurrency HomeControlWebSocketDelegate {
    func homeControlWebSocket(
        _ homeControlWebSocket: HomeControlWebSocket,
        didCreateInverterReading inverterReading: Stored<InverterReading>
    ) {
        appState.latestInverterReading = inverterReading
    }

    func homeControlWebSocket(
        _ homeControlWebSocket: HomeControlWebSocket,
        didSaveSetting setting: HomeControlKit.Setting
    ) {

    }
}
