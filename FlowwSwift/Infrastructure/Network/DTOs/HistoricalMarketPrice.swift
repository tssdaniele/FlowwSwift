//
//  HistoricalMarketPrice.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation

// MARK: - HistoricalMarketPrice
struct HistoricalMarketPrice: Codable {
    let prices: [[Double]]
    let marketCap: [[Double]]
    let totalVolumes: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices = "prices"
        case marketCap = "market_caps"
        case totalVolumes = "total_volumes"
    }
    
    func toModel(id: String,
                 name: String,
                 symbol: String,
                 thumbnailImage: String) -> PriceChartModel {
        let prices = self.prices.map {
            (time: Date(timeIntervalSince1970: $0[0] / 1000), price: $0[1])
        }
        
        let marketCap = self.marketCap.map {
            (time: Date(timeIntervalSince1970: $0[0] / 1000), marketCap: $0[1])
        }
        
        let totalVolumes = self.totalVolumes.map {
            (time: Date(timeIntervalSince1970: $0[0] / 1000), volume: $0[1])
        }
        
        return .init(id: id,
                     name: name,
                     symbol: symbol,
                     thumbnailImage: thumbnailImage,
                     prices: prices,
                     marketCap: marketCap,
                     volume: totalVolumes)
    }
}
