//
//  HomesWithCurrentSubscriptionAndPricingInfo.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import Foundation

public struct HomesWithCurrentSubscriptionAndPricingInfo: Codable {
    public var homes: [Home]

    public struct Home: Codable {
        public var currentSubscription: Subscription

        public struct Subscription: Codable {
            public var status: String
            public var priceInfo: PriceInfo

            public struct PriceInfo: Codable {
                public var today: [PriceInfoEntry]
                public var tomorrow: [PriceInfoEntry]?

                public struct PriceInfoEntry: Codable {
                    public var total: Double
                    public var energy: Double
                    public var tax: Double
                    public var startsAt: Date
                }
            }
        }
    }
}
