//
//  ChargeFinderSettingsView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 12.03.25.
//

import HomeControlKit
import Logging
import SwiftUI

struct ChargeFinderSettingsView: View {
    @Environment(AppState.self) var appState
    @Environment(\.dismiss) var dismiss
    @State private var chargeFinderSettings: ChargeFinderSettings?
    private let logger = Logger(homeControl: "mobile.charge-finder-settings-view")

    var body: some View {
        Form {
            if let chargeFinderSettings {
//                public var rangeTimeInterval: TimeInterval
//                public var numberOfCompareRanges: Int
//                public var compareRangePercentage: Double
//                public var minimumForceChargingRangeTimeInterval: TimeInterval
//                public var maximumForceChargingRangeTimeInterval: TimeInterval
//                public var maximumElectricityPrice: Double

                Toggle(
                    "Is Vehicle Charging Allowed",
                    isOn: .init(
                        get: { chargeFinderSettings.isVehicleChargingAllowed ?? true },
                        set: { self.chargeFinderSettings?.isVehicleChargingAllowed = $0 }
                    )
                )
                VStack {
                    HStack {
                        Text("Target State of Charge")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(chargeFinderSettings.targetStateOfCharge ?? 1, format: .percent)
                    }
                    Slider(
                        value: .init(
                            get: { chargeFinderSettings.targetStateOfCharge ?? 1 },
                            set: { self.chargeFinderSettings?.targetStateOfCharge = $0 }
                        ),
                        in: 0...1,
                        step: 0.05
                    )
                }
            }
        }
        .navigationTitle("Charge Finder")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save", action: saveAndDismiss)
                    .disabled(chargeFinderSettings == nil)
            }
        }
        .task {
            chargeFinderSettings = try? await appState.homeControlClient.settings.get(setting: .chargeFinderSetting)
        }
    }

    private func saveAndDismiss() {
        guard let chargeFinderSettings else { return }
        Task {
            do {
                try await appState.homeControlClient.settings.save(setting: .chargeFinderSetting, chargeFinderSettings)
                dismiss()
            } catch {
                logger.critical("Failed to save \(error)")
            }
        }
    }
}

#Preview {
    ChargeFinderSettingsView()
}
