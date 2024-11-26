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
                    toggleView(title: "Enabled", messageType: .inverterForceChargingEnabled)
                    toggleView(title: "Disabled", messageType: .inverterForceChargingDisabled)
                }

                Section("Electricity Prices") {
                    toggleView(title: "Updated", messageType: .electricityPricesUpdated)
                }

                Section("Charge Finder") {
                    toggleView(title: "Force Charging Ranges Created", messageType: .chargeFinderCreatedForceChargingRanges)
                }

                Section("Wallbox Ecomatic") {
                    toggleView(title: "Did Update Logic Mode", messageType: .wallboxEcomaticDidUpdateLogicMode)
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
                    newSettings[messageType] = settings.value
                } catch {
                    logger.critical("Failed to get push device settings for \(messageType) \(error)")
                }
            }
            DispatchQueue.main.async {
                self.messageTypeSettings = newSettings
            }
        }
    }

    private func sendSettings(messageType: MessageType, settings: PushDeviceMessageTypeSettings) {
        guard let token = appState.pushDeviceToken else { return }

        Task {
            do {
                try await appState.homeControlClient.pushDevice.updateSettings(
                    deviceToken: token,
                    messageType: messageType,
                    settings: settings
                )
            } catch {
                logger.critical("Failed to update push device settings: \(error)")
                updateSettings()
            }
        }
    }

    @ViewBuilder
    private func toggleView(title: String, messageType: MessageType) -> some View {
        Toggle(
            isOn: .init(
                get: { messageTypeSettings[messageType]?.isEnabled ?? false },
                set: { enabled in
                    var settings = messageTypeSettings[messageType] ?? .init(isEnabled: false)
                    settings.isEnabled = enabled
                    messageTypeSettings[messageType] = settings

                    sendSettings(messageType: messageType, settings: settings)
                }
            ),
            label: {
                Text(title)
            }
        )
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
