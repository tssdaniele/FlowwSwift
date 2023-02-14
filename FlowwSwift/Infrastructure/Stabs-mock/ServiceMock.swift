//
//  ServiceMockable.swift
//  FlowwSwiftTests
//
//  Created by Daniele Tassone on 10/02/2023.
//

import Foundation

protocol ServiceMockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> Result<T, APIError>
}

extension ServiceMockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> Result<T, APIError> {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)
            return .success(decodedObject)
        } catch  {
            return .failure(APIError.decode(error))
        }
    }
}


final class ServiceMock: ServiceMockable, CoinGeckoServiceable {
    func getCoins() async -> Result<Coins, APIError> {
        return loadJSON(filename: "coinsData", type: Coins.self)
    }
    
    func getHistoricalMarketPriceWithId(id: String) async -> Result<HistoricalMarketPrice, APIError> {
        return loadJSON(filename: "marketData", type: HistoricalMarketPrice.self)
    }
    
    func getHistoricalMarketPriceWithQuery(query: CoinsMarketChartQuery) async -> Result<HistoricalMarketPrice, APIError> {
        return loadJSON(filename: "marketData", type: HistoricalMarketPrice.self)
    }
}
