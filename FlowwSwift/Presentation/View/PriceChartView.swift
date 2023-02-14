//
//  PriceChartView.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//

import Charts
import SwiftUI

struct PriceChartView<ViewModel>: View where ViewModel: PriceChartVMProtocol {
    @StateObject private var viewModel: ViewModel
    @State var rangeTime: (start: Date, end: Date)? = nil
    @State var rangePrice: (start: Double, end: Double)? = nil
    init (viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_BR")
        return dateFormatter
    }
}

extension PriceChartView {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack {
                        ImageView(url: URL(string: viewModel.thumbnailImage))
                        Text(viewModel.symbol.uppercased()).font(.title).bold()
                    }
                    Text(viewModel.currentPrice).font(.headline)
                    Text(dateFormatter.string(from: Date())).font(.body).foregroundColor(.gray)
                }
                VStack(alignment: .trailing) {
                    if let rangeTime = rangeTime,
                       let rangePrice = rangePrice {
                        Group {
                            Text(dateFormatter.string(from: rangeTime.start))
                            Text(viewModel.format.stringWithCurrency(fromNumber: rangePrice.start, currencyCode: "USD"))
                            Text(dateFormatter.string(from: rangeTime.end))
                            Text(viewModel.format.stringWithCurrency(fromNumber: rangePrice.end, currencyCode: "USD"))
                        }.font(.footnote)
                    }
                }.padding(10).frame(maxWidth: .infinity, alignment: .trailing)
            }
            Chart {
                ForEach(viewModel.model.prices, id: \.time) { element in
                    LineMark(
                        x: .value("Day", element.time, unit: .day),
                        y: .value("Prices", element.price)
                    )
                }
                //.interpolationMethod(.linear)
                .lineStyle(StrokeStyle(lineWidth: 3))
                //.symbolSize(100)
                .foregroundStyle(.blue)
                if let (startT, endT) = rangeTime {
                    RectangleMark(
                        xStart: .value("Selection Start", startT),
                        xEnd: .value("Selection End", endT)
                    )
                    .foregroundStyle(.green.opacity(0.2))
                }
            }
            .chartForegroundStyleScale([
                "Prices": .blue
            ])
            .chartSymbolScale([
                "Prices": Circle().strokeBorder(lineWidth: 3)
            ])
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) {
                    AxisTick()
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                }
            }
            .chartYAxis(.automatic)
            .chartYScale(range: .plotDimension(endPadding: 0))
            .chartLegend(.automatic)
            .chartOverlay { proxy in
                        GeometryReader { nthGeoItem in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                                .gesture(DragGesture()
                                    .onChanged { value in
                                        // Find the x-coordinates in the chart’s plot area.
                                        let xStart = value.startLocation.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                        let xCurrent = value.location.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                        // Find the date values at the x-coordinates.
                                        if let dateStart: Date = proxy.value(atX: xStart),
                                           let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                            rangeTime = (dateStart, dateCurrent)
                                        }
                                            let yStart = value.startLocation.y - nthGeoItem[proxy.plotAreaFrame].origin.y
                                            let yCurrent = value.location.y - nthGeoItem[proxy.plotAreaFrame].origin.y

                                            if let priceStart: Double = proxy.value(atY: yStart),
                                               let priceCurrent: Double = proxy.value(atY: yCurrent) {
                                                rangePrice = (priceStart, priceCurrent)
                                        }
                                    }
                                    .onEnded { _ in rangeTime = nil; rangePrice = nil } // Clear the state on gesture end.
                                )
                        }
                    }
        }.padding(8)
            .onAppear { viewModel.fetchData() }
    }
}

struct PriceChartView_Previews: PreviewProvider {
    static var previews: some View {
        PriceChartView(viewModel: PriceChartVM(service: ServiceMock(), id: "bitcoin", name: "Bitcoin", currentPrice: "$22.9K", symbol: "btc", thumbnailImage: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"))
    }
}
