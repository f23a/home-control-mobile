//
//  ForceChargingRange+Initial.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 19.02.25.
//

import Foundation
import HomeControlKit

extension ForceChargingRange {
    static var initialValue: ForceChargingRange {
        .init(
            startsAt: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
            endsAt: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date(),
            targetStateOfCharge: 1,
            state: .planned,
            source: .user,
            isVehicleChargingAllowed: true
        )
    }
}
