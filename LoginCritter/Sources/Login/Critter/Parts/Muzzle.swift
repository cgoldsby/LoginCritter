//
//  Muzzle.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Muzzle: UIImageView, CritterAnimatable {

    private let p1 = CGPoint(x: 24, y: 43)
    private let p2 = CGPoint(x: 11.2, y: 48)

    convenience init() {
        self.init(image: UIImage.Critter.muzzle)
        frame = CGRect(x: p1.x, y: p1.y, width: 57.5, height: 46.3)
    }

    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }

    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
