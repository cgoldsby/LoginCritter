//
//  Muzzle.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Muzzle: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.muzzle)
        frame = CGRect(x: 24, y: 43, width: 57.5, height: 46.3)
    }

    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        let p1 = CGPoint(x: 24, y: 43)
        let p2 = CGPoint(x: 12.9, y: 45.1)

        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }

    func applyActiveEndState() {
        let p1 = CGPoint(x: 24, y: 43)
        let p2 = CGPoint(x: 12.9, y: 45.1)

        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
