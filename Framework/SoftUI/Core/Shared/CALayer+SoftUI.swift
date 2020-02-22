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
    private static var _soft_tag = Holder<Int>()
    var soft_tag: Int {
        set (value) {
            CALayer._soft_tag[self.hash] = value
        }
        get {
            return CALayer._soft_tag[self.hash] ?? -1
        }
    }

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

//    private static var _soft_outerLightShadowLayer = Holder<CALayer>()
//    var soft_outerLightShadowLayer: CALayer? {
//        set (layer) {
//            CALayer._soft_outerLightShadowLayer[self.hash] = layer
//        }
//        get {
//            return CALayer._soft_outerLightShadowLayer[self.hash]
//        }
//    }
//
//    private static var _soft_outerDarkShadowLayer = Holder<CALayer>()
//    var soft_outerDarkShadowLayer: CALayer? {
//        set (layer) {
//            CALayer._soft_outerDarkShadowLayer[self.hash] = layer
//        }
//        get {
//            return CALayer._soft_outerDarkShadowLayer[self.hash]
//        }
//    }
//
//    private static var _soft_innerShadowLayer = Holder<CALayer>()
//    var soft_innerShadowLayer: CALayer? {
//        set (layer) {
//            CALayer._soft_innerShadowLayer[self.hash] = layer
//        }
//        get {
//            return CALayer._soft_innerShadowLayer[self.hash]
//        }
//    }
//
//    private static var _soft_mainColorLayer = Holder<CALayer>()
//    var soft_mainColorLayer: CALayer? {
//        set (layer) {
//            CALayer._soft_mainColorLayer[self.hash] = layer
//        }
//        get {
//            return CALayer._soft_mainColorLayer[self.hash]
//        }
//    }

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

    private static var _soft_lightSource = Holder<LightSource>()
    var soft_lightSource: LightSource {
        set (type) {
            CALayer._soft_lightSource[self.hash] = type
            self.soft_update()
        }
        get {
            return CALayer._soft_lightSource[self.hash] ?? .none
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

    private func soft_colorLayer() -> CALayer {
        let layer = CALayer()

        layer.soft_tag = 1
        layer.frame = self.bounds

        return layer
    }

    private func soft_shadowLayer() -> CALayer {
        let layer =  CALayer(layer: self)

        layer.soft_tag = 2
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = self.bounds

        layer.soft_updateCorners(with: self.soft_cornerType,
                                 and: self.soft_cornerRadius)

        return layer
    }

    private func soft_update() {
        self.sublayers?.removeAll(where: { $0.soft_tag > 0 })

        // Main layer
        let mainColorLayer = self.soft_colorLayer()
        mainColorLayer.soft_updateCorners(with: self.soft_cornerType,
                                          and: self.soft_cornerRadius)
        mainColorLayer.backgroundColor = self.soft_mainColor
        self.backgroundColor = UIColor.clear.cgColor
        self.insertSublayer(mainColorLayer, at: 0)

        // Shadow
        if let shadowDistance = self.soft_shadowDistance, shadowDistance > 0 {
            if let lightColor = self.soft_outerLightShadowColor {
                let shadowLayer = self.soft_shadowLayer()

                shadowLayer.soft_updateShadow(of: .light,
                distance: shadowDistance,
                lightSource: self.soft_lightSource,
                color: lightColor)

                self.insertSublayer(shadowLayer, below: mainColorLayer)
            }

            if let darkColor = self.soft_outerDarkShadowColor {
                let shadowLayer = self.soft_shadowLayer()

                shadowLayer.soft_updateShadow(of: .dark,
                distance: shadowDistance,
                lightSource: self.soft_lightSource,
                color: darkColor)

                self.insertSublayer(shadowLayer, below: mainColorLayer)
            }
        }
    }
}

extension CALayer {
    fileprivate func soft_updateShadow(of type: ShadowType,
                                       distance: CGFloat = 5,
                                       intensity: CGFloat = 1,
                                       blur: CGFloat = 1,
                                       lightSource: LightSource = .topLeft,
                                       color: CGColor?) {
        self.shadowColor = color
        self.shadowOpacity = Float(intensity)
        self.shadowRadius = distance * blur

        var offset = CGSize(width: distance, height: distance)

        switch lightSource {
        case .topLeft:
            offset = CGSize(width: type == .light ? -distance : distance,
                            height: type == .light ? -distance : distance)
        case .topRight:
            offset = CGSize(width: type == .light ? distance : -distance,
                            height: type == .light ? -distance : distance)
        case .bottomLeft:
            offset = CGSize(width: type == .dark ? distance : -distance,
                        height: type == .dark ? -distance : distance)
        case .bottomRight:
            offset = CGSize(width: type == .dark ? -distance : distance,
                        height: type == .dark ? -distance : distance)
        default: break
        }

        self.shadowOffset = offset
    }
}

extension CALayer {
    fileprivate func soft_updateCorners(with type: CornerType, and radius: CGFloat) {
        if type == .none { return }

        self.cornerRadius = radius

        switch type {
        case .all:
            self.maskedCorners = [.layerMaxXMaxYCorner,
                                  .layerMaxXMinYCorner,
                                  .layerMinXMaxYCorner,
                                  .layerMinXMinYCorner]
        case .bottom:
            self.maskedCorners = [.layerMaxXMaxYCorner,
                                  .layerMinXMaxYCorner]
        case .top:
            self.maskedCorners = [.layerMaxXMinYCorner,
                                  .layerMinXMinYCorner]
        default: break
        }
    }
}
