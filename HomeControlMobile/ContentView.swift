//
//  ContentView.swift
//  Home Control Mobile
//
//  Created by Christoph Pageler on 27.09.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeTabView()
            ForceChargingTabView()
            SettingsTabView()
        }
    }
}

#Preview {
    ContentView()
}
