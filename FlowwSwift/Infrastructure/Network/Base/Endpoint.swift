//
//  Endpoint.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 09/02/2023.
//
import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: APIMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "api.coingecko.com" }
}
