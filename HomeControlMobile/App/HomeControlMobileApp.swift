//
//  HomeControlMobileApp.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 27.09.24.
//

import SwiftUI

@main
struct HomeControlMobileApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appDelegate.appState)
        }
    }
}
