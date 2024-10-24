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
    var body: some View {
        Text("Home")
//            .task { await tibber() }
            .tabItem { Label("Home", systemImage: "house") }
    }

//    private func tibber() async {
//        let tibber = TibberSwift(apiKey: HomeControlKit.Environment.require("TIBBER_API_KEY"))
//        let homes = try? await tibber.customOperation(.homesWithCurrentSubscriptionAndPricingInfo())
//        print("Homes: \(homes)")
//    }
}
