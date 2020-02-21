//
//  UIView+SoftUI.swift
//  SoftUI
//
//  Created by Ivan Manov on 21.02.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
@IBDesignable
public extension UIView {
    @IBInspectable
    var soft_cornerRadius: CGFloat {
        set (radius) {
            self.layer.soft_cornerRadius = radius
        }
        get {
            return self.layer.soft_cornerRadius
        }
    }

    @IBInspectable
    var soft_shadowRadius: CGFloat {
        set (radius) {
            self.layer.soft_shadowRadius = radius
        }
        get {
            return self.layer.soft_shadowRadius
        }
    }

    @IBInspectable
    var soft_cornerType: String {
        set (type) {
            self.layer.soft_cornerType = CornerType(rawValue: type) ?? .none
        }
        get {
            return self.layer.soft_cornerType.rawValue
        }
    }
}
