//
//  MarketListViewModel.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Foundation

protocol MarketListVMProtocol: ObservableObject {
    var service: CoinGeckoServiceable { get }
    var format: Format { get }
    var model: [MarketListModel] { get set }
    var alert: AlertInfo? { get set }
    init(service: CoinGeckoServiceable)
    // MARK: Methods
    func fetchData()
}

final class MarketListVM: MarketListVMProtocol {
    @Published var model: [MarketListModel]
    @Published var alert: AlertInfo?
    var format = Format()
    var service: CoinGeckoServiceable
    init(service: CoinGeckoServiceable) {
        self.service = service
        model = [MarketListModel]()
        fetchData()
    }
    
    func fetchData() {
        Task {
            switch await service.getCoins() {
            case.success(let coins):
                DispatchQueue.main.async {
                    self.model = coins.map { $0.toModel() }
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
