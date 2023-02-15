//
//  TimeRangePicker.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 14/02/2023.
//

import SwiftUI

enum TimeRangeChart: String, Equatable {
    case lastSixMonths = "6M"
    case lastYear = "1Y"
    case lastTwoYears = "2Y"
    case lastFourYears = "4Y"
    case max = "All"
}

struct TimeRangePicker: View {
    @Binding var value: TimeRangeChart
    var onChange: (_: TimeRangeChart) -> Void
    
    var body: some View {
        Picker("Time Range", selection: $value.animation(.easeInOut)) {
            Text(TimeRangeChart.lastSixMonths.rawValue).tag(TimeRangeChart.lastSixMonths)
            Text(TimeRangeChart.lastYear.rawValue).tag(TimeRangeChart.lastYear)
            Text(TimeRangeChart.lastTwoYears.rawValue).tag(TimeRangeChart.lastTwoYears)
            Text(TimeRangeChart.lastFourYears.rawValue).tag(TimeRangeChart.lastFourYears)
            Text(TimeRangeChart.max.rawValue).tag(TimeRangeChart.max)
        }
        .pickerStyle(.segmented)
        .onChange(of: value, perform: onChange)
    }
}
