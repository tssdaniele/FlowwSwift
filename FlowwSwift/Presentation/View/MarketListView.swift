//
//  MarketListView.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import SwiftUI

struct MarketListView<ViewModel>: View where ViewModel: MarketListVMProtocol {
    @StateObject private var viewModel: ViewModel
    @State private var searchCoins: String = ""
    init (viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

extension MarketListView {
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.model, id: \.self) {  crypto in
                    NavigationLink(destination: PriceChartView(viewModel: PriceChartVM(service: viewModel.service, id: crypto.id, name: crypto.name, currentPrice: viewModel.format.stringWithCurrency(fromNumber: Double(crypto.currentPrice), currencyCode: "USD"), symbol: crypto.symbol, thumbnailImage: crypto.thumbnailImage))) {
                        HStack {
                            ImageView(url: URL(string: crypto.thumbnailImage))
                            VStack(alignment: .leading) {
                                Text(crypto.symbol.uppercased())
                                Text(viewModel.format.stringWithCurrency(fromNumber: Double(crypto.marketCap), currencyCode: "USD"))
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(viewModel.format.currency(currencyCode: "USD" , value: crypto.currentPrice))
                                if crypto.priceChangePercentage24H > 0 {
                                    Text(viewModel.format.percentage(value: crypto.priceChangePercentage24H))
                                }
                                else {
                                    Text(viewModel.format.percentage(value: crypto.priceChangePercentage24H))
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(3)
                    }
                }
            }.listStyle(.inset)
                .navigationBarTitle("Markets")
                .searchable(text: $searchCoins)
                .alert(item: $viewModel.alert, content: { info in
                    Alert(title: Text(info.title),
                          message: Text(info.message),
                          dismissButton: .cancel())
                }).padding()
        }
    }
}

struct MarketListView_Previews: PreviewProvider {
    static var previews: some View {
        MarketListView(viewModel: MarketListVM(service: ServiceMock()))
    }
}
