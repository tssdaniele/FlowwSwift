//
//  CoinGeckoEndpoint.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation

enum CoinGeckoEndpoint {
    case coinsMarkets(query: CoinsMarketsQuery)
    case marketChart(query: CoinsMarketChartQuery)
}

extension CoinGeckoEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .coinsMarkets:
            return "/api/v3/coins/markets"
        case .marketChart(let query):
            return "/api/v3/coins/\(query.id)/market_chart"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .coinsMarkets(let query):
            var urlQueryItems = [URLQueryItem(name: "vs_currency", value: query.vsCurrency)]
            if let ids = query.ids
            { urlQueryItems.append(URLQueryItem(name: "ids", value: ids)) }
            if let category = query.category
            { urlQueryItems.append(URLQueryItem(name: "category", value: category)) }
            if let order = query.order
            { urlQueryItems.append(URLQueryItem(name: "order", value: order.rawValue)) }
            if let perPage = query.perPage
            { urlQueryItems.append(URLQueryItem(name: "per_page", value: String(perPage))) }
            if let page = query.page
            { urlQueryItems.append(URLQueryItem(name: "page", value: String(page))) }
            urlQueryItems.append(URLQueryItem(name: "sparkline", value: String(query.sparkline)))
            if let priceChangePercentage = query.priceChangePercentage
            { urlQueryItems.append(URLQueryItem(name: "price_change_percentage", value: String(priceChangePercentage))) }

            return urlQueryItems
            
        case .marketChart(let query):
            var urlQueryItems = [
                    URLQueryItem(name: "vs_currency", value: query.vsCurrency),
                    URLQueryItem(name: "days", value: query.days)
                ]
            
            if let interval = query.interval
            { urlQueryItems.append(URLQueryItem(name: "interval", value: interval)) }
            
            return urlQueryItems
        }
    }
    
    var method: APIMethod {
        switch self {
        case .coinsMarkets, .marketChart:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .coinsMarkets, .marketChart:
            return nil
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .coinsMarkets, .marketChart:
            return nil
        }
    }
}

///Use this to obtain all the coins market data (price, market cap, volume)
struct CoinsMarketsQuery {
    ///The target currency of market data (usd, eur, jpy, etc.)
    ///(Required)
    let vsCurrency: String
    
    ///The ids of the coin, comma separated crytocurrency symbols (base). refers to /coins/list
    let ids: String?
    
    ///Filter by coin category. Refer to /coin/categories/list
    let category: String?
    
    ///Valid values: market_cap_desc, gecko_desc, gecko_asc, market_cap_asc, market_cap_desc, volume_asc, volume_desc, id_asc, id_desc.
    ///Sort results by field.
    let order: Order?
    
    ///Valid values: 1..250
    ///Total results per page
    let perPage: Int?
    
    ///Page through results
    let page: Int?
    
    ///Include sparkline 7 days data (eg. true, false)
    var sparkline: Bool = false
    
    ///Include price change percentage in 1h, 24h, 7d, 14d, 30d, 200d, 1y (eg. '1h,24h,7d' comma-separated, invalid values will be discarded)
    let priceChangePercentage: String?
    
    ///Init
    init(vsCurrency: String, ids: String? = nil, category: String? = nil, order: Order? = nil, perPage: Int? = nil, page: Int? = nil, priceChangePercentage: String? = nil) {
        self.vsCurrency = vsCurrency
        self.ids = ids
        self.category = category
        self.order = order
        self.perPage = perPage
        self.page = page
        self.priceChangePercentage = priceChangePercentage
    }
    
    enum Order: String {
        case geckoDesc = "gecko_desc"
        case geckoAsc = "gecko_asc"
        case marketCapAsc = "market_cap_asc"
        case marketCapDesc = "market_cap_desc"
        case volumeAsc = "volume_asc"
        case volumeDesc = "volume_desc"
        case idAsc = "id_asc"
        case idDesc = "id_desc"
    }
}

///Use this to obtain all the coins market data (price, market cap, volume)
struct CoinsMarketChartQuery {
    ///Pass the coin id (can be obtained from /coins) eg. bitcoin
    ///Required (path)
    var id: String
    
    ///The target currency of market data (usd, eur, jpy, etc.)
    ///Required (query)
    let vsCurrency: String
    
    ///Data up to number of days ago (eg. 1,14,30,max)
    ///Required (query)
    let days: String
    
    ///Data interval. Possible value: dail
    ///(query)
    let interval: String?
    
    ///Init
    init(id: String, vsCurrency: String, days: String, interval: String? = nil) {
        self.id = id
        self.vsCurrency = vsCurrency
        self.days = days
        self.interval = interval
    }
}

