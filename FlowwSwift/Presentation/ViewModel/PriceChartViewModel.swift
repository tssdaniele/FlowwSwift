//
//  PriceChartViewModel.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation

protocol PriceChartVMProtocol: ObservableObject {
    var service: CoinGeckoServiceable { get }
    var model: PriceChartModel { get set }
    var alert: AlertInfo? { get set }
    var format: Format { get }
    var id: String { get set }
    var name: String { get set }
    var currentPrice: String { get set }
    var symbol: String { get set }
    var thumbnailImage: String { get set }
    init(service: CoinGeckoServiceable,
         id: String,
         name: String,
         currentPrice: String,
         symbol: String,
         thumbnailImage: String)
    // MARK: Methods
    func fetchData()
}

final class PriceChartVM: PriceChartVMProtocol {
    @Published var model: PriceChartModel
    @Published var alert: AlertInfo?
    var service: CoinGeckoServiceable
    var id, name, currentPrice, symbol, thumbnailImage: String
    var format = Format()
    
    init(service: CoinGeckoServiceable,
         id: String,
         name: String,
         currentPrice: String,
         symbol: String,
         thumbnailImage: String) {
        self.service = service
        self.id = id
        self.name = name
        self.thumbnailImage = thumbnailImage
        self.symbol = symbol
        self.currentPrice = currentPrice
        model = PriceChartModel()
    }
    
    func fetchData() {
        Task {
            switch await service.getHistoricalMarketPriceWithId(id: id) {
            case.success(let prices):
                DispatchQueue.main.async {
                    self.model = prices.toModel(id: self.id,
                                                name: self.name,
                                                symbol: self.symbol,
                                                thumbnailImage: self.thumbnailImage)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alert = AlertInfo(
                        id: .info,
                        title: error.customMessage,
                        message: error.localizedDescription
                    )
                }
            }
        }
    }
}
