//
//  Enums.swift
//  SoftUI
//
//  Created by Ivan Manov on 21.02.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import Foundation

public enum ShadowType {
    case none
    case light
    case dark
}

public enum LightSource: String {
    case none
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    var startEndPoints: (CGPoint, CGPoint) {
        switch self {
        case .topLeft, .none:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .topRight:
            return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        case .bottomLeft:
            return (CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 0))
        case .bottomRight:
            return (CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 0))
        }
    }
}

public enum ShapeType {
    case none
    case flat
    case concave
    case convex
    case pressed
}

public enum CornerType: String {
    case none
    case all
    case top
    case middle
    case bottom
}
