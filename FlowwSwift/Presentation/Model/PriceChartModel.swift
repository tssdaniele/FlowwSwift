//
//  PriceChartModel.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation

// MARK: - PriceChartModel
///The chart should:
///- Plot dates on the x axis
///- Plot price on the y axis
struct PriceChartModel: Identifiable {
    /// The id of the cryptocurrency.
    let id: String
    
    /// The name of the cryptocurrency.
    let name: String
    
    /// The symbol of the cryptocurrency.
    let symbol: String
    
    /// The thumbnail of the cryptocurrency.
    let thumbnailImage: String
    
    ///Price series
    /// The `time` property is a `Date` that represents the exact time.
    let prices: [(time: Date, price: Double)]
    
    ///Market cap series
    /// The `time` property is a `Date` that represents the exact time.
    let marketCap: [(time: Date, marketCap: Double)]
  
    ///Volume series
    /// The `time` property is a `Date` that represents the exact time.
    let volume: [(time: Date, volume: Double)]
    
    
    init(id: String, name: String, symbol: String, thumbnailImage: String, prices: [(time: Date, price: Double)], marketCap: [(time: Date, marketCap: Double)], volume: [(time: Date, volume: Double)]) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.thumbnailImage = thumbnailImage
        self.prices = prices
        self.marketCap = marketCap
        self.volume = volume
    }
    
    init() {
        self.id = String()
        self.name = String()
        self.symbol = String()
        self.thumbnailImage = String()
        self.prices = [(time: Date, price: Double)]()
        self.marketCap =  [(time: Date, marketCap: Double)]()
        self.volume = [(time: Date, volume: Double)]()
    }
}
