//
//  AppState.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 26.10.24.
//

import HomeControlKit
import SwiftUI

@Observable class AppState {
    var latestInverterReading: Stored<InverterReading>?
}
