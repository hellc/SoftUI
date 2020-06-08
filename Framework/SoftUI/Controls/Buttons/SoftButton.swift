//
//  SoftButton.swift
//  SoftUI
//
//  Created by Ivan Manov on 22.02.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import UIKit

public class SoftButton: UIButton {
    public override var state: UIControl.State {
        let state = super.state
        self.updateShape(for: state)

        return state

    }

    private func updateShape(for state: UIControl.State) {
        switch state {
        case .normal:
            self.layer.soft_shapeType = .flat
        case .highlighted:
            self.layer.soft_shapeType = .pressed
        case .focused:
            self.layer.soft_shapeType = .concave
        case .selected:
            self.layer.soft_shapeType = .pressed
        default:
            self.layer.soft_shapeType = .flat
        }
    }
}
