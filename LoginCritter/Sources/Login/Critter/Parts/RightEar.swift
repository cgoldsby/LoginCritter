//
//  RightEar.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class RightEar: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.rightEar)
        frame = CGRect(x: 77.9, y: -3.3, width: 36.6, height: 36.6)
    }

    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -2)
            .translate(.y, by: 12)
            .rotate(.z, by: 8.0.degrees)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -10)
    }
}
