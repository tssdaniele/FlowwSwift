//
//  AlertInfo.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 10/02/2023.
//

import Foundation

struct AlertInfo: Identifiable {
    enum AlertType {
        case info
    }
    let id: AlertType
    let title: String
    let message: String
}
