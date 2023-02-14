//
//  MarketListModel.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation


// MARK: - MarketListModel
///A list item should contain:
///- Market cap rank
///- Thumbnail image
///- Symbol
///- Market cap
///- Price
///- 24hr price change (percentage)
struct MarketListModel: Hashable {
    let id: String
    let name: String
    let symbol: String
    let thumbnailImage: String
    let marketCap: Int
    let marketCapRank: Int
    let currentPrice: Double
    let priceChangePercentage24H: Double
}
