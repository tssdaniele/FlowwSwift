//
//  FlowwSwiftTests.swift
//  FlowwSwiftTests
//
//  Created by Daniele Tassone on 09/02/2023.
//

import XCTest
@testable import FlowwSwift

final class FlowwSwiftTests: XCTestCase {

    func testCoinGeckoServiceMock() async {
        let serviceMock = ServiceMock()
        let coinsResult = await serviceMock.getCoins()
        let chartResult = await serviceMock.getHistoricalMarketPriceWithId(id: "stub")
        switch coinsResult {
        case .success(let coins):
            XCTAssertFalse(coins.isEmpty)
        case .failure(let error):
            XCTAssertThrowsError(error.localizedDescription)
        }
        
        switch chartResult {
        case .success(let chart):
            XCTAssertFalse(chart.prices.isEmpty)
            let chartModel = chart.toModel(name: "stub1",
                                           symbol: "stub2",
                                           thumbnailImage: "stub3")
            XCTAssertFalse(chartModel.prices.isEmpty)
        case .failure(let error):
            XCTAssertThrowsError(error.localizedDescription)
        }
    }
    
    func testCoinGeckoService() async {
        let service = CoinGeckoService()
        let coinsResult = await service.getCoins()
        let chartResult = await service.getHistoricalMarketPriceWithId(id: "thorchain")
        switch coinsResult {
        case .success(let coins):
            XCTAssertFalse(coins.isEmpty)
        case .failure(let error):
            XCTFail(error.customMessage)
        }
        
        switch chartResult {
        case .success(let chart):
            XCTAssertFalse(chart.prices.isEmpty)
        case .failure(let error):
            XCTFail(error.customMessage)
        }
    }

}
