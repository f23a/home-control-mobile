//
//  BatteryLevelAppIntent.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 24.09.24.
//

//import AppIntents
//import HomeControlClient
//import HomeControlKit
//
//struct BatteryLevelAppIntent: AppIntent {
//    static var title = LocalizedStringResource("Battery Level")
//
//    func perform() async throws -> some IntentResult & ReturnsValue<Double> {
//        let client = HomeControlClient.usingLocalIPAddress
//        let latestInverterReading = try await client.inverterReading.latest()
//        let level = latestInverterReading.value.batteryLevel
//        return .result(value: level)
//    }
//}
