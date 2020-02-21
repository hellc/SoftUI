//
//  CALayer+SoftUI.swift
//  SoftUI
//
//  Created by Ivan Manov on 21.02.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import UIKit

typealias Holder<T> = [Int: T]

// swiftlint:disable identifier_name
public extension CALayer {
    private static var _soft_outerShadowLayer = Holder<CALayer>()
    var soft_outerShadowLayer: CALayer? {
        set (layer) {
            CALayer._soft_outerShadowLayer[self.hash] = layer
        }
        get {
            return CALayer._soft_outerShadowLayer[self.hash]
        }
    }

    private static var _soft_innerShadowLayer = Holder<CALayer>()
    var soft_innerShadowLayer: CALayer? {
        set (layer) {
            CALayer._soft_innerShadowLayer[self.hash] = layer
        }
        get {
            return CALayer._soft_innerShadowLayer[self.hash]
        }
    }

    private static var _soft_mainColorLayer = Holder<CALayer>()
    var soft_mainColorLayer: CALayer? {
        set (layer) {
            CALayer._soft_mainColorLayer[self.hash] = layer
        }
        get {
            return CALayer._soft_mainColorLayer[self.hash]
        }
    }

    private static var _soft_mainColor = Holder<CGColor>()
    var soft_mainColor: CGColor? {
        set (value) {
            CALayer._soft_mainColor[self.hash] = value
            self.soft_update()
        }
        get {
            if let mainColor = CALayer._soft_mainColor[self.hash] {
                return mainColor
            }

            CALayer._soft_mainColor[self.hash] = self.backgroundColor
            self.backgroundColor = nil

            return CALayer._soft_mainColor[self.hash]
        }
    }

    private static var _soft_cornerRadius = Holder<CGFloat>()
    var soft_cornerRadius: CGFloat {
        set (value) {
            CALayer._soft_cornerRadius[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_cornerRadius[self.hash] ?? 0.0
        }
    }

    private static var _soft_shadowRadius = Holder<CGFloat>()
    var soft_shadowRadius: CGFloat {
        set (value) {
            CALayer._soft_shadowRadius[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_shadowRadius[self.hash] ?? 0.0
        }
    }

    private static var _soft_cornerType = Holder<CornerType>()
    var soft_cornerType: CornerType {
        set (type) {
            CALayer._soft_cornerType[self.hash] = type
            self.soft_update()
        }
        get {
            return CALayer._soft_cornerType[self.hash] ?? .none
        }
    }

    private func prepareSublayers() {
        if self.soft_outerShadowLayer == nil {
            self.soft_outerShadowLayer = CALayer()
            self.insertSublayer(self.soft_outerShadowLayer!, at: 0)
        }

        if self.soft_mainColorLayer == nil {
            self.soft_mainColorLayer = CALayer()
            self.soft_mainColorLayer?.frame = self.bounds
            self.insertSublayer(self.soft_mainColorLayer!, at: 1)
        }
    }

    private func soft_update() {
        self.prepareSublayers()

        // Main layer
        guard let mainColorLayer = self.soft_mainColorLayer else { return }
        mainColorLayer.backgroundColor = self.soft_mainColor
        mainColorLayer.soft_updateCorners(with: self.soft_cornerType, and: self.soft_cornerRadius)

        // Shadow
        guard let outerShadowLayer = self.soft_outerShadowLayer else { return }
        let shadowRadius = self.soft_shadowRadius
        if shadowRadius > 0 {
            var frame = self.bounds

            frame.origin.x -= shadowRadius
            frame.origin.y -= shadowRadius
            frame.size.height += shadowRadius * 2
            frame.size.width += shadowRadius * 2

            outerShadowLayer.frame = frame

            outerShadowLayer.backgroundColor = UIColor.red.cgColor
            outerShadowLayer.soft_updateCorners(with: self.soft_cornerType, and: self.soft_cornerRadius * 2)
        }

        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
}

extension CALayer {
    private func soft_round(_ corners: UIRectCorner, with radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds,
                                 byRoundingCorners: corners,
                                 cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.mask = mask
     }

    fileprivate func soft_updateCorners(with type: CornerType, and radius: CGFloat) {
        if type == .none { return }

        switch type {
        case .all:
            self.soft_round([.allCorners], with: radius)
        case .bottom:
            self.soft_round([.bottomLeft, .bottomRight], with: radius)
        case .top:
            self.soft_round([.topLeft, .topRight], with: radius)
        default: break
        }
    }
}
