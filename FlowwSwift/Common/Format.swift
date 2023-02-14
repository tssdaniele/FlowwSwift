//
//  Format.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 11/02/2023.
//

import Foundation

extension Format {
    enum Unit: String {
        case none = ""
        case K
        case M
        case B
    }
}

class Format: Formatter {

    private let numberFormatter = NumberFormatter()
    private let unitSize: [Unit: Double] = [.none: 1,
                                            .K: 1000,
                                            .M: pow(1000, 2),
                                            .B: pow(1000, 3)]

    func string(fromNumber number: Int) -> String {
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .down
        return convertValue(fromNumber: number)
    }

    override func string(for obj: Any?) -> String? {
        guard let value = obj as? Double else {
            return nil
        }

        return string(fromNumber: Int(value))
    }
    
    func stringWithCurrency(fromNumber number: Double,
                            currencyCode: String) -> String {
        numberFormatter.roundingMode = .down
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode
        return convertValue(fromNumber: Int(), fromDouble: number)
    }
    
    func currency(currencyCode: String,
                   value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.currencyCode = currencyCode
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "n/a"
    }
    
    func percentage(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.negativePrefix = "-"
        return "\(formatter.string(from: NSNumber(value: value)) ?? "")%"
    }

    // MARK: - Private Methods
    private func convertValue(fromNumber number: Int, fromDouble: Double? = nil) -> String {
        let number = fromDouble ?? Double(number)
        if number == 0 {
            return partsToIncludeFor(value: "Zero", unit: .none)
        } else {
            if number == 1 || number == -1 {
                return formatNumberFor(number: number, unit: .none)
            }else if number < unitSize[.K]! && number > -unitSize[.K]! {
                return divide(number, by: unitSize, for: .none)
            } else if number < unitSize[.M]! && number > -unitSize[.M]! {
                return divide(number, by: unitSize, for: .K)
            } else if number < unitSize[.B]! && number > -unitSize[.B]! {
                return divide(number, by: unitSize, for: .M)
            } else {
                return divide(number, by: unitSize, for: .B)
            }
        }
    }

    private func divide(_ number: Double, by unitSize: [Unit: Double], for unit: Unit) -> String {
        guard let numberSizeUnit = unitSize[unit] else {
            fatalError("Cannot find value \(unit)")
        }
        let result = number/numberSizeUnit
        return formatNumberFor(number: result, unit: unit)
    }

    private func formatNumberFor(number: Double, unit: Unit) -> String {

        switch unit {
        case .none, .K:
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 2
            let result = numberFormatter.string(from: NSNumber(value: number))
            return partsToIncludeFor(value: result!, unit: unit)
        case .M:
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 2
            let result = numberFormatter.string(from: NSNumber(value: number))
            return partsToIncludeFor(value: result!, unit: unit)
        case .B:
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 1
            let result = numberFormatter.string(from: NSNumber(value: number))
            return partsToIncludeFor(value: result!, unit: unit)
        }

    }

    private func partsToIncludeFor(value: String, unit: Unit) -> String {
        if value == "Zero" {
            return "0\(unit.rawValue)"
        } else {
            return "\(value)\(unit.rawValue)"
        }
    }

    private func lengthOfInt(number: Int) -> Int {
        guard number != 0 else {
            return 1
        }
        var num = abs(number)
        var length = 0

        while num > 0 {
            length += 1
            num /= 10
        }
        return length
    }
}
