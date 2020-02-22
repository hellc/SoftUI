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
    var soft_shadowDistance: CGFloat {
        set (distance) {
            self.layer.soft_shadowDistance = distance
        }
        get {
            return self.layer.soft_shadowDistance ?? 0
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

    @IBInspectable
    var soft_lightSource: String {
        set (type) {
            self.layer.soft_lightSource = LightSource(rawValue: type) ?? .none
        }
        get {
            return self.layer.soft_lightSource.rawValue
        }
    }

    @IBInspectable
    var soft_outerLightShadowColor: UIColor {
        set (color) {
            self.layer.soft_outerLightShadowColor = color.cgColor
        }
        get {
            if let cgColor = self.layer.soft_outerLightShadowColor {
                return UIColor(cgColor: cgColor)
            } else {
                return .clear
            }
        }
    }

    @IBInspectable
    var soft_outerDarkShadowColor: UIColor {
        set (color) {
            self.layer.soft_outerDarkShadowColor = color.cgColor
        }
        get {
            if let cgColor = self.layer.soft_outerDarkShadowColor {
                return UIColor(cgColor: cgColor)
            } else {
                return .clear
            }
        }
    }
}
