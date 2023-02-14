//
//  FlowwSwiftApp.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import SwiftUI

@main
struct FlowwSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            MarketListView(viewModel: MarketListVM(service: CoinGeckoService()))
                .environment(\.locale, Locale(identifier: "en_BR"))
        }
    }
}
