//
//  LeftEar.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class LeftEar: UIImageView, CritterAnimatable {
    
    convenience init() {
        self.init(image: UIImage.Critter.leftEar)
        frame = CGRect(x: -9.1, y: -3.3, width: 36.6, height: 36.6)
    }
    
    // MARK: - CritterAnimatable
    
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: 10)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: 2)
            .translate(.y, by: 12)
            .rotate(.z, by: -8.0.degrees)
    }
}
