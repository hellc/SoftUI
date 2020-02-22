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
