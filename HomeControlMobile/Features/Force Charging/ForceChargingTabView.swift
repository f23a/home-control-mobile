//
//  ForceChargingTabView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import HomeControlClient
import HomeControlKit
import HomeControlLogging
import Logging
import SwiftUI

struct ForceChargingTabView: View {
    private let logger = Logger(homeControl: "mobile.force-charging-tab-view")
    @Environment(AppState.self) var appState

    @State private var forceChargingRanges: [Stored<ForceChargingRange>]?
    @State private var sheet: SheetType?

    var body: some View {
        NavigationStack {
            List {
                ForEach(forceChargingRanges ?? []) { forceChargingRange in
                    Button(
                        action: { sheet = .edit(forceChargingRange: forceChargingRange) },
                        label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(forceChargingRange.value.startsAt, format: .dateTime)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "arrow.right")
                                    Text("\(forceChargingRange.value.endsAt, format: .dateTime)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                HStack {
                                    Text("Target SoC \(forceChargingRange.value.targetStateOfCharge, format: .percent)")
                                    Spacer()
                                    Text("\(forceChargingRange.value.state)")
                                    Spacer()
                                    Text("\(forceChargingRange.value.source)")
                                }
                                .foregroundStyle(.secondary)
                                .font(.callout)
                            }
                        }
                    )
                    .buttonStyle(.plain)
                }
                .onDelete(perform: onDelete)
            }
            .refreshable { await updateForceChargingRanges() }
            .navigationTitle("Force Charging")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(
                        action: { sheet = .new },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
            .sheet(
                item: $sheet,
                onDismiss: {
                    Task { await updateForceChargingRanges() }
                },
                content: { sheet in
                    switch sheet {
                    case .new:
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
                    case let .edit(forceChargingRange):
                        NavigationStack {
                            EditForceChargingRangeView(
                                id: forceChargingRange.id,
                                forceChargingRange: forceChargingRange.value
                            )
                        }
                    }
                }
            )
        }
        .task { await updateForceChargingRanges() }
        .tabItem { Label("Force Charging", systemImage: "bolt") }
    }

    private func updateForceChargingRanges() async {
        do {
            let query = ForceChargingRangeQuery(
                pagination: .init(page: 1, per: 1000),
                filter: [],
                sort: .init(value: .startsAt, direction: .descending)
            )
            forceChargingRanges = try await appState.homeControlClient.forceChargingRanges.query(query).items
        } catch {
            logger.critical("Failed to get force charging ranges \(error)")
        }
    }

    private func onDelete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        guard let forceChargingRange = forceChargingRanges?[safe: index] else { return }

        Task {
            do {
                try await appState.homeControlClient.forceChargingRanges.delete(id: forceChargingRange.id)
            } catch {
                logger.critical("Failed to delete \(error)")
            }
            await updateForceChargingRanges()
        }
    }

    enum SheetType: Identifiable {
        case new
        case edit(forceChargingRange: Stored<ForceChargingRange>)

        var id: String {
            switch self {
            case .new:
                return "new"
            case .edit(let forceChargingRange):
                return "edit-\(forceChargingRange.id)"
            }
        }
    }
}

#Preview {
    TabView {
        ForceChargingTabView()
    }
}
