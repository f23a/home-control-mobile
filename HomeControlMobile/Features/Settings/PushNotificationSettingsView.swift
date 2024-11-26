//
//  PushNotificationSettingsView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 25.11.24.
//

import HomeControlKit
import Logging
import SwiftUI

struct PushNotificationSettingsView: View {
    private let logger = Logger(homeControl: "mobile.push-notification-settings-view")

    @Environment(AppState.self) var appState

    @State private var isPushEnabled = false
    @State private var messageTypeSettings: [MessageType: PushDeviceMessageTypeSettings] = [:]

    var body: some View {
        List {
            Section("General") {
                Toggle("Enable", isOn: $isPushEnabled)
                if let token = appState.pushDeviceToken {
                    VStack(alignment: .leading) {
                        Text("Device Token")
                        Text(token)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if isPushEnabled {
                Section("Inverter Force Charging") {
                    show settings
                    Toggle("Enabled", isOn: .constant(false))
                    Toggle("Disabled", isOn: .constant(false))
                }

                Section("Electricity Prices") {
                    Toggle("Updated", isOn: .constant(false))
                }

                Section("Charge Finder") {
                    Toggle("Force Charging Ranges Created", isOn: .constant(false))
                }

                Section("Wallbox Ecomatic") {
                    Toggle("Did Update Logic Mode", isOn: .constant(false))
                }
            }
        }
        .navigationTitle("Push Notifications")
        .onAppear {
            isPushEnabled = appState.isPushEnabled
            updateSettings()
        }
        .onChange(of: isPushEnabled) {
            if isPushEnabled {
                appState.requestRemoteNotificationsIfNeeded()
            } else {
                appState.unregisterForRemoteNotifications()
            }
        }
        .onChange(of: appState.pushDeviceToken) {
            updateSettings()
        }
    }

    private func updateSettings() {
        guard let token = appState.pushDeviceToken else {
            messageTypeSettings = [:]
            return
        }

        let messageTypes = [
            MessageType.inverterForceChargingEnabled,
            .inverterForceChargingDisabled,
            .electricityPricesUpdated,
            .chargeFinderCreatedForceChargingRanges,
            .wallboxEcomaticDidUpdateLogicMode
        ]

        logger.info("Get Settings for \(token)")
        let client = appState.homeControlClient
        Task {
            var newSettings: [MessageType: PushDeviceMessageTypeSettings] = [:]
            for messageType in messageTypes {
                do {
                    let settings = try await client.pushDevice.settings(
                        deviceToken: token,
                        messageType: messageType
                    )
                    newSettings[messageType] = settings
                } catch {
                    logger.critical("Failed to get push device settings for \(messageType) \(error)")
                }
            }
            DispatchQueue.main.async {
                self.messageTypeSettings = newSettings
            }
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            PushNotificationSettingsView()
        }
    }
    .environment(AppState(defaultEndpoint: .localIPAddressMacBook))
}
