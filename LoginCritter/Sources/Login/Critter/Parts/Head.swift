//
//  Head.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Head: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.head)
        frame = CGRect(x: 27.3, y: 52.1, width: 105.5, height: 90.9)
    }

    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .rotate(.x, by: -20.0.degrees)
            .rotate(.y, by: -18.0.degrees)
            .perspective()
    }

    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .rotate(.x, by: -20.0.degrees)
            .rotate(.y, by: 18.0.degrees)
            .perspective()
    }
}
