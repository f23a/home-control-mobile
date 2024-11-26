//
//  SettingsTabView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import SwiftUI

struct SettingsTabView: View {
    @Environment(AppState.self) var appState
    @State private var endpoint: Endpoint?

    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    endpointPickerView
                    NavigationLink(
                        "Push Notifications",
                        destination: PushNotificationSettingsView()
                    )
                }
                Section("Remote") {
                    NavigationLink("Adapter Sungrow Converter", destination: Text(""))
                    NavigationLink("Force Charging", destination: Text(""))
                }

            }
            .navigationTitle("Settings")
        }
        .onAppear {
            endpoint = appState.endpoint
        }
        .onChange(of: endpoint) { oldValue, newValue in
            guard oldValue != nil, let newValue else { return }
            appState.changeEndpoint(to: newValue)
        }
        .tabItem { Label("Settings", systemImage: "gear") }
    }

    private var endpointPickerView: some View {
        Picker("Endpoint", selection: $endpoint) {
            ForEach(Endpoint.allCases) { endpoint in
                Text(endpoint.displayName)
                    .tag(endpoint as Endpoint?)
            }
        }
    }
}

#Preview {
    TabView {
        SettingsTabView()
    }
    .environment(AppState(defaultEndpoint: .localIPAddressMacBook))
}
