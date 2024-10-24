//
//  SettingsTabView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        Text("Settings")
            .tabItem { Label("Settings", systemImage: "gear") }
    }
}
