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
    private static var _soft_outerLightShadowColor = Holder<CGColor>()
    var soft_outerLightShadowColor: CGColor? {
        set (value) {
            CALayer._soft_outerLightShadowColor[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_outerLightShadowColor[self.hash]
        }
    }

    private static var _soft_outerDarkShadowColor = Holder<CGColor>()
    var soft_outerDarkShadowColor: CGColor? {
        set (value) {
            CALayer._soft_outerDarkShadowColor[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_outerDarkShadowColor[self.hash]
        }
    }

    private static var _soft_outerLightShadowLayer = Holder<CALayer>()
    var soft_outerLightShadowLayer: CALayer? {
        set (layer) {
            CALayer._soft_outerLightShadowLayer[self.hash] = layer
        }
        get {
            return CALayer._soft_outerLightShadowLayer[self.hash]
        }
    }

    private static var _soft_outerDarkShadowLayer = Holder<CALayer>()
    var soft_outerDarkShadowLayer: CALayer? {
        set (layer) {
            CALayer._soft_outerDarkShadowLayer[self.hash] = layer
        }
        get {
            return CALayer._soft_outerDarkShadowLayer[self.hash]
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

    private static var _soft_shadowDistance = Holder<CGFloat>()
    var soft_shadowDistance: CGFloat? {
        set (value) {
            CALayer._soft_shadowDistance[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_shadowDistance[self.hash]
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
        if self.soft_outerDarkShadowLayer == nil {
            self.soft_outerDarkShadowLayer = CALayer()
            self.soft_outerDarkShadowLayer?.backgroundColor = UIColor.black.cgColor
            self.soft_outerDarkShadowLayer?.frame = self.bounds
            self.insertSublayer(self.soft_outerDarkShadowLayer!, at: 0)
        }

        if self.soft_outerLightShadowLayer == nil {
            self.soft_outerLightShadowLayer = CALayer()
            self.soft_outerLightShadowLayer?.backgroundColor = UIColor.black.cgColor
            self.soft_outerLightShadowLayer?.frame = self.bounds
            self.insertSublayer(self.soft_outerLightShadowLayer!, at: 1)
        }

        if self.soft_mainColorLayer == nil {
            self.soft_mainColorLayer = CALayer()
            self.soft_mainColorLayer?.frame = self.bounds
            self.insertSublayer(self.soft_mainColorLayer!, at: 2)
        }
    }

    private func soft_update() {
        self.prepareSublayers()

        // Main layer
        guard let mainColorLayer = self.soft_mainColorLayer else { return }
        mainColorLayer.soft_updateCorners(with: self.soft_cornerType,
                                          and: self.soft_cornerRadius)
        mainColorLayer.backgroundColor = self.soft_mainColor
        self.backgroundColor = UIColor.clear.cgColor

        guard let outerLightShadowLayer = self.soft_outerLightShadowLayer else { return }
        outerLightShadowLayer.soft_updateCorners(with: self.soft_cornerType,
                                                 and: self.soft_cornerRadius)

        guard let outerDarkShadowLayer = self.soft_outerDarkShadowLayer else { return }
        outerDarkShadowLayer.soft_updateCorners(with: self.soft_cornerType,
                                                 and: self.soft_cornerRadius)

        // Shadow
        if let shadowDistance = self.soft_shadowDistance, shadowDistance > 0 {
            outerLightShadowLayer.soft_updateShadow(with: .light,
                                                    distance: shadowDistance,
                                                    lightSource: .topLeft,
                                                    color: self.soft_outerLightShadowColor)
            outerDarkShadowLayer.soft_updateShadow(with: .dark,
                                                    distance: shadowDistance,
                                                    lightSource: .topLeft,
                                                    color: self.soft_outerDarkShadowColor)
        }
    }
}

extension CALayer {
    fileprivate func soft_updateShadow(with type: ShadowType,
                                       distance: CGFloat = 5,
                                       lightSource: LightSource = .topLeft,
                                       color: CGColor?) {
        self.shadowColor = color
        self.shadowOpacity = 1.0
        self.shadowRadius = distance

        var offset = CGSize(width: distance, height: distance)

        switch lightSource {
        case .topLeft:
            offset = CGSize(width: type == .light ? -distance : distance,
                            height: type == .light ? -distance : distance)
        default: break
        }

        self.shadowOffset = offset
    }
}

extension CALayer {
    private func soft_round(_ corners: UIRectCorner, with radius: CGFloat) {
        self.masksToBounds = false
        let path = UIBezierPath(roundedRect: self.bounds,
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
