//
//  AppDelegate.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 28.09.24.
//

import Foundation
import HomeControlClient
import HomeControlKit
import HomeControlLogging
import Logging
import UIKit
import UserNotifications


@MainActor
class AppDelegate: NSObject {
    private let logger = Logger(homeControl: "mobile.app-delegate")
    private(set) var appState = AppState()

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
        logger.info("Did register for remote notifications \(tokenString)")
//        Task.detached {
//            do {
//                try await self.homeControlClient.pushDevice.register(pushDevice: .init(deviceToken: tokenString))
//
//                try await self.homeControlClient.pushDevice.updateSettings(
//                    deviceToken: tokenString,
//                    messageType: .electricityPricesUpdated,
//                    settings: .init(isEnabled: true)
//                )
//            } catch {
//                print("Failed to register device \(error)")
//            }
//        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        logger.critical("Failed to register for remote notifications: \(error)")
    }
}
