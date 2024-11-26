//
//  HistoryTabView.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 27.10.24.
//

import Charts
import HomeControlKit
import Logging
import SwiftUI

struct HistoryTabView: View {
    private let logger = Logger(homeControl: "mobile.history-tab-view")

    enum DateSpan {
        case day
        case week
        case month
        case sixMonths
        case year
    }

    struct InverterReading: Identifiable {
        var id: String { "\(date)" }
        var date: Date
        var value: Double
    }

    @State private var dateSpan = DateSpan.week
    @State private var readings: [InverterReading] = []
    @State private var scrollPosition = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("", selection: $dateSpan) {
                    Text("T").tag(DateSpan.day)
                    Text("W").tag(DateSpan.week)
                    Text("M").tag(DateSpan.month)
                    Text("6 M.").tag(DateSpan.sixMonths)
                    Text("J").tag(DateSpan.year)
                }
                .pickerStyle(.segmented)

                // https://swiftwithmajid.com/2023/07/25/mastering-charts-in-swiftui-scrolling/
                Chart {
                    ForEach(readings) { reading in
                        LineMark(
                            x: .value("Date", reading.date),
                            y: .value("Value", reading.value)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: 30)
                .chartScrollPosition(x: $scrollPosition)
                .chartScrollPosition(initialX: Date())
                .chartScrollTargetBehavior(
                    .valueAligned(unit: 30, majorAlignment: .page)
                )
                .onChange(of: scrollPosition) {
                    logger.info("Scroll \(scrollPosition)")
                }
            }
            .navigationTitle("History")
        }
        .tabItem { Label("History", systemImage: "chart.xyaxis.line") }
        .onAppear {
            let initialDate = Date().addingTimeInterval(-50 * 20)
            readings = Array(0..<100).map {
                let date = initialDate.addingTimeInterval(Double($0 * 20))
                return InverterReading(
                    date: date,
                    value: Double($0)
                )
            }
        }
    }
}

#Preview {
    HistoryTabView()
}
