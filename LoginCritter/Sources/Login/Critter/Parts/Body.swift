//
//  Body.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Body: UIImageView, CritterAnimatable {
    
    convenience init() {
        self.init(image: UIImage.Critter.body)
        layer.zPosition = -30
        frame = CGRect(x: 33.9, y: 109.2, width: 92.1, height: 73.4)
    }
    
    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .perspective()
            .rotate(.y, by: -12.degrees)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .perspective()
            .rotate(.y, by: 12.degrees)
    }
}
