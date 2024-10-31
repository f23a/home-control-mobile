//
//  HomeTabView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import HomeControlKit
import SwiftUI
// import TibberSwift

struct HomeTabView: View {
    @Environment(AppState.self) var appState

    var body: some View {
        NavigationStack {
            List {
                if let latestInverterReading = appState.latestInverterReading {
                    Section("Age") {
                        Text(latestInverterReading.value.readingAt, style: .relative)
                    }
                    Section("From") {
                        Text("Grid: \(latestInverterReading.value.formatted(\.fromGrid))")
                        Text("Solar: \(latestInverterReading.value.formatted(\.fromSolar))")
                        Text("Battery: \(latestInverterReading.value.formatted(\.fromBattery))")
                    }
                    Section("To") {
                        Text("Grid: \(latestInverterReading.value.formatted(\.toGrid))")
                        Text("Battery: \(latestInverterReading.value.formatted(\.toBattery))")
                    }
                    Section("Battery") {
                        Text("Level: \(latestInverterReading.value.formatted(\.batteryLevel))")
                        Text("State: \(latestInverterReading.value.batteryState)")
                        Text("Health: \(latestInverterReading.value.formatted(\.batteryHealth))")
                    }
                } else {
                    Section("Inverter Reading") {
                        Text("Empty")
                    }
                }
            }
            .navigationTitle("Home")
        }
        .tabItem { Label("Home", systemImage: "house") }
//            .task { await tibber() }
    }

//    private func tibber() async {
//        let tibber = TibberSwift(apiKey: HomeControlKit.Environment.require("TIBBER_API_KEY"))
//        let homes = try? await tibber.customOperation(.homesWithCurrentSubscriptionAndPricingInfo())
//        print("Homes: \(homes)")
//    }
}
