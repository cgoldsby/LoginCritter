//
//  Nose.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Nose: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.nose)
        frame = CGRect(x: 22.4, y: 1.7, width: 12.7, height: 9.6)
    }

    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        let p1 = CGPoint(x: 22.4, y: 1.7)
        let p2 = CGPoint(x: 13.2, y: 5.2)

        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }
    
    func applyActiveEndState() {
        let p1 = CGPoint(x: 22.4, y: 1.7)
        let p2 = CGPoint(x: 13.2, y: 5.2)

        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
