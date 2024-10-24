//
//  EditForceChargingRangeView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import HomeControlClient
import HomeControlKit
import SwiftUI

struct EditForceChargingRangeView: View {
    @SwiftUI.Environment(\.dismiss) var dismiss

    let id: UUID?
    @State var forceChargingRange: ForceChargingRange

    var body: some View {
        Form {
            DatePicker("Starts at", selection: $forceChargingRange.startsAt)
            DatePicker("Ends at", selection: $forceChargingRange.endsAt)
            Stepper(
                value: $forceChargingRange.targetStateOfCharge,
                in: 0...1,
                step: 0.05,
                format: .percent,
                label: {
                    HStack {
                        Text("Target SoC")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(forceChargingRange.targetStateOfCharge, format: .percent)")
                    }

                }
            )
            Picker("State", selection: $forceChargingRange.state) {
                Text("Planned").tag(ForceChargingRangeState.planned)
                Text("Sent").tag(ForceChargingRangeState.sent)
            }
            Picker("Source", selection: $forceChargingRange.source) {
                Text("User").tag(ForceChargingRangeSource.user)
                Text("Automatic").tag(ForceChargingRangeSource.automatic)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    Task { await save() }
                }
            }
        }
        .navigationTitle("Force Charging")
    }

    private func save() async {
        let client = HomeControlClient.usingLocalIPAddress
        do {
            let storedForceChargingRange: Stored<ForceChargingRange>
            if let id {
                storedForceChargingRange = try await client.forceChargingRanges.update(id: id, forceChargingRange)
            } else {
                storedForceChargingRange = try await client.forceChargingRanges.create(forceChargingRange)
            }

            print("Stored force charging range \(storedForceChargingRange.id)")

            dismiss()
        } catch {

        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            EditForceChargingRangeView(
                id: nil,
                forceChargingRange: .init(
                    startsAt: Date(),
                    endsAt: Date(),
                    targetStateOfCharge: 1,
                    state: .planned,
                    source: .user
                )
            )
        }
    }
}
