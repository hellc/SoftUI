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
internal extension CALayer {
    private static var _soft_useSoftUI = Holder<Bool>()
    var soft_useSoftUI: Bool {
        set (value) {
            CALayer._soft_useSoftUI[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_useSoftUI[self.hash] ?? false
        }
    }

    private static var _soft_tag = Holder<Int>()
    var soft_tag: Int {
        set (value) {
            CALayer._soft_tag[self.hash] = value
        }
        get {
            return CALayer._soft_tag[self.hash] ?? -1
        }
    }

    private static var _soft_lightColor = Holder<CGColor>()
    var soft_lightColor: CGColor? {
        set (value) {
            CALayer._soft_lightColor[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_lightColor[self.hash]
        }
    }

    private static var _soft_darkColor = Holder<CGColor>()
    var soft_darkColor: CGColor? {
        set (value) {
            CALayer._soft_darkColor[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_darkColor[self.hash]
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

    private static var _soft_intensity = Holder<CGFloat>()
    var soft_intensity: CGFloat {
        set (value) {
            CALayer._soft_intensity[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_intensity[self.hash] ?? 0.5
        }
    }

    private static var _soft_borderWidth = Holder<CGFloat>()
    var soft_borderWidth: CGFloat {
        set (value) {
            CALayer._soft_borderWidth[self.hash] = value
            self.soft_update()
        }
        get {
            return CALayer._soft_borderWidth[self.hash] ?? 0.0
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

    private static var _soft_shapeType = Holder<ShapeType>()
    var soft_shapeType: ShapeType {
        set (type) {
            CALayer._soft_shapeType[self.hash] = type
            self.soft_update()
        }
        get {
            return CALayer._soft_shapeType[self.hash] ?? .flat
        }
    }

    private static var _soft_lightSource = Holder<LightSource>()
    var soft_lightSource: LightSource {
        set (type) {
            CALayer._soft_lightSource[self.hash] = type
            self.soft_update()
        }
        get {
            return CALayer._soft_lightSource[self.hash] ?? .topLeft
        }
    }

    private static var _soft_cornerType = Holder<CornerType>()
    var soft_cornerType: CornerType {
        set (type) {
            CALayer._soft_cornerType[self.hash] = type
            self.soft_update()
        }
        get {
            return CALayer._soft_cornerType[self.hash] ?? .all
        }
    }

    private func soft_colorLayer() -> CALayer {
        let layer = CAShapeLayer()

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
                                 and: self.soft_cornerRadius + 4)

        return layer
    }

    // swiftlint:disable function_body_length
    private func soft_update() {
        if !self.soft_useSoftUI { return }

        self.sublayers?.removeAll(where: { $0.soft_tag > 0 })

        // Main layer
        let mainColorLayer = self.soft_colorLayer()
        mainColorLayer.soft_updateCorners(with: self.soft_cornerType,
                                          and: self.soft_cornerRadius)
        mainColorLayer.backgroundColor = self.soft_mainColor
        self.backgroundColor = UIColor.clear.cgColor
        self.insertSublayer(mainColorLayer, at: 0)

        // Shadow
        let lightColor = self.soft_lightColor
        let darkColor = self.soft_darkColor
        if let shadowDistance = self.soft_shadowDistance, shadowDistance > 0, self.soft_shapeType != .pressed {
            if lightColor != nil {
                let shadowLayer = self.soft_shadowLayer()

                shadowLayer.soft_updateShadow(of: .light,
                distance: shadowDistance,
                intensity: self.soft_intensity,
                lightSource: self.soft_lightSource,
                color: lightColor)

                self.insertSublayer(shadowLayer, below: mainColorLayer)
            }

            if darkColor != nil {
                let shadowLayer = self.soft_shadowLayer()

                shadowLayer.soft_updateShadow(of: .dark,
                distance: shadowDistance,
                intensity: self.soft_intensity,
                lightSource: self.soft_lightSource,
                color: darkColor)

                self.insertSublayer(shadowLayer, below: mainColorLayer)
            }
        }

        if lightColor != nil, darkColor != nil {
            // Border
            if self.soft_borderWidth > 0 {
                let border = self.soft_gradient(for: self.soft_lightSource,
                                                colors: [lightColor!, lightColor!, lightColor!, darkColor!])

                let shape = CAShapeLayer()
                shape.lineWidth = self.soft_borderWidth
                shape.path = self.soft_path(for: self.soft_cornerType, radius: self.soft_cornerRadius)
                shape.strokeColor = UIColor.black.cgColor
                shape.fillColor = UIColor.clear.cgColor
                border.mask = shape

                mainColorLayer.insertSublayer(border, at: 0)
                mainColorLayer.masksToBounds = true
            }

            // Shape
            switch self.soft_shapeType {
            case .concave, .convex, .pressed:
                mainColorLayer.updateShape(for: self.soft_lightSource,
                                           with: self.soft_shapeType,
                                           lightColor: lightColor!,
                                           darkColor: darkColor!)
            default: break
            }
        }
    }

    private func updateShape(for lightSource: LightSource,
                             with type: ShapeType,
                             lightColor: CGColor,
                             darkColor: CGColor) {
        let lightColor = lightColor.copy(alpha: 0.1)!
        let darkColor = darkColor.copy(alpha: 0.1)!

        var colors: [CGColor] = []
        var locations: [NSNumber] = []
        var gradientType: CAGradientLayerType = .axial

        let gradient = CAGradientLayer()
        gradient.startPoint = lightSource.startEndPoints.0
        gradient.endPoint = lightSource.startEndPoints.1

        switch type {
        case .concave:
            colors = [darkColor, lightColor]
            locations = [0, 1]
            gradientType = .axial
        case .convex:
            colors = [lightColor, darkColor]
            locations = [0, 1]
            gradientType = .axial
        case .pressed:
            colors = [darkColor, lightColor]
            locations = [0, 1]
            gradientType = .radial
        default: break
        }

        gradient.type = gradientType
        gradient.frame = self.bounds
        gradient.colors = colors

        gradient.locations = locations

        self.insertSublayer(gradient, at: 0)
        self.masksToBounds = true
    }
}

extension CALayer {
    fileprivate func soft_gradient(for type: LightSource,
                                   colors: [CGColor],
                                   gradientType: CAGradientLayerType = .axial,
                                   locations: [NSNumber] = [0, 0.5, 0.5, 1]) -> CALayer {
        let gradient = CAGradientLayer()

        gradient.type = gradientType
        gradient.frame = self.bounds
        gradient.colors = colors

        gradient.locations = locations
        gradient.startPoint = type.startEndPoints.0
        gradient.endPoint = type.startEndPoints.1

        return gradient
    }

    fileprivate func soft_path(for type: CornerType, radius: CGFloat) -> CGPath {
        var roundingCorners: UIRectCorner = [.allCorners]

        switch type {
        case .all:
            roundingCorners = [.allCorners]
        case .bottom:
            roundingCorners = [.bottomLeft, .bottomRight]
        case .top:
            roundingCorners = [.topLeft, .topRight]
        default: break
        }

        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: roundingCorners,
                                cornerRadii: CGSize(width: radius, height: radius))

        return path.cgPath
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
