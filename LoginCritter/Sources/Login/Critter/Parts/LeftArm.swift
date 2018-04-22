//
//  LeftArm.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/22/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class LeftArm: UIImageView {

    var isShy = false

    convenience init() {
        self.init(image: UIImage.Critter.leftArm)
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
}
