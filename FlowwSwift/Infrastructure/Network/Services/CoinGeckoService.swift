//
//  CoinGeckoService.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation

protocol CoinGeckoServiceable {
    var query: CoinsMarketsQuery { get }
    func getCoins() async -> Result<Coins, APIError>
    func getHistoricalMarketPriceWithId(id: String) async -> Result<HistoricalMarketPrice, APIError>
    func getHistoricalMarketPriceWithQuery(query: CoinsMarketChartQuery) async -> Result<HistoricalMarketPrice, APIError>
}

extension CoinGeckoServiceable {
    var query: CoinsMarketsQuery {
        CoinsMarketsQuery(
            vsCurrency: "usd",
            order: .marketCapDesc,
            perPage: 250
        )
    }
}

struct CoinGeckoService: APIClient, CoinGeckoServiceable {
    func getCoins() async -> Result<Coins, APIError> {
       let query = CoinsMarketsQuery(vsCurrency: "usd", order: .marketCapDesc, perPage: 250)
        return await sendRequest(endpoint: CoinGeckoEndpoint.coinsMarkets(query: query), responseModel: Coins.self)
    }
    
    func getHistoricalMarketPriceWithId(id: String) async -> Result<HistoricalMarketPrice, APIError> {
        let query = CoinsMarketChartQuery(id: id, vsCurrency: "usd", days: "365")
        return await sendRequest(endpoint: CoinGeckoEndpoint.marketChart(query: query), responseModel: HistoricalMarketPrice.self)
    }
    
    func getHistoricalMarketPriceWithQuery(query: CoinsMarketChartQuery) async -> Result<HistoricalMarketPrice, APIError> {
        return await sendRequest(endpoint: CoinGeckoEndpoint.marketChart(query: query), responseModel: HistoricalMarketPrice.self)
    }
}
