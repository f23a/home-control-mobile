//
//  AppDelegate.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 28.09.24.
//

import Foundation
import HomeControlClient
import UIKit
import UserNotifications

class AppDelegate: NSObject {
    private(set) var homeControlClient: HomeControlClient

    override init() {
        homeControlClient = .init(address: "192.168.178.90", port: 8080)!
        homeControlClient.authToken = Environment.require("AUTH_TOKEN")
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
            } catch {
                print("Failed to register device \(error)")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register")
    }
}
