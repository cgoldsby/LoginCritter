//
//  RightEye.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class RightEye: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.eye)
        frame = CGRect(x: 72.4, y: 28.8, width: 11.7, height: 11.7)
    }

    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        let eyeScale: CGFloat = 1.12
        let eyeTransform = CATransform3D
            .identity
            .scale(.x, by: eyeScale)
            .scale(.y, by: eyeScale)
            .scale(.z, by: 1.01) // 🎩✨ Magic to prevent 'jumping'

        let p1 = CGPoint(x: 72.4, y: 28.8)
        let p2 = CGPoint(x: 62.1, y: 37)

        layer.transform = eyeTransform
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }

    func applyActiveEndState() {
        let eyeScale: CGFloat = 1.12
        let eyeTransform = CATransform3D
            .identity
            .scale(.x, by: eyeScale)
            .scale(.y, by: eyeScale)
            .scale(.z, by: 1.01) // 🎩✨ Magic to prevent 'jumping'

        let p1 = CGPoint(x: 72.4, y: 28.8)
        let p2 = CGPoint(x: 62.1, y: 37)

        layer.transform = eyeTransform
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
