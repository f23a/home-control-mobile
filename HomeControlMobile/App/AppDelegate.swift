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

@MainActor
class AppDelegate: NSObject {
    private let logger = Logger(homeControl: "mobile.app-delegate")
    private(set) var appState = AppState()

    override init() {
        super.init()

        LoggingSystem.bootstrapHomeControl()
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        logger.info("Did register for remote notifications \(tokenString)")
        appState.updatePushDeviceToken(tokenString)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        logger.critical("Failed to register for remote notifications: \(error)")
    }
}
