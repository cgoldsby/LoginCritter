//
//  LeftArm.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/22/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class LeftArm: UIImageView, CritterAnimatable {

    var isShy = false

    convenience init() {
        self.init(image: UIImage.Critter.leftArm)
        layer.zPosition = 30
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }

        let originY = superview.bounds.maxY
        frame = CGRect(x: 25.1, y: originY, width: 42.3, height: 93.2)
    }

    func applyShyState() {
        if isShy {
            layer.transform = CATransform3D
                .identity
                .translate(.y, by: -82.6)
        }
        else {
            layer.transform = .identity
        }
    }

    func applyPeekState() {
        layer.transform = CATransform3D
            .identity
            .translate(.y, by: -70.6)
    }

    func applyUnPeekState() {
        if isShy {
            applyShyState()
        }
        else {
            applyInactiveState()
        }
    }
}
