//
//  ImageView.swift
//  FlowwSwift
//
//  Created by Daniele Tassone on 10/02/2023.
//

import Foundation
import SwiftUI

struct ImageView: View {
    let url: URL?
    let width: CGFloat?
    let height: CGFloat?
    let clipShapeType: ShapeType?
    
    init(url: URL?, width: CGFloat? = nil, height: CGFloat? = nil, clipShapeType: ShapeType? = nil) {
        self.url = url
        self.width = width
        self.height = height
        self.clipShapeType = clipShapeType
    }
    
    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .transition(.scale(scale: 0.1, anchor: .center))
            case .failure:
                Image(systemName: "wifi.slash")
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: width ?? 44, height: height ?? 44)
        .background(Color.white)
        .clipShape(clipShapeType ?? .circle)
    }
}


enum ShapeType: String, CaseIterable, Shape {
    case circle = "Circle"
    case ellipse = "Ellipse"
    case capsule = "Capsule"
    case rounded = "Rounded Rectangle"
    case rectangle = "Rectangle"
    
    func path(in rect: CGRect) -> Path {
        switch self {
            case .circle: return Circle().path(in: rect)
            case .ellipse: return Ellipse().path(in: rect)
            case .capsule: return Capsule().path(in: rect)
            case .rounded: return RoundedRectangle(cornerRadius: 25.0).path(in: rect)
            case .rectangle: return Rectangle().path(in: rect)
        }
    }
}
