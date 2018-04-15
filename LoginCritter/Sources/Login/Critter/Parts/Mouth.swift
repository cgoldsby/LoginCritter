//
//  Mouth.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Mouth: UIImageView, CritterAnimatable {
    
    convenience init() {
        self.init(image: UIImage.Critter.mouthFull)
        frame = CGRect(x: 15.5, y: 24.6, width: 26.4, height: 18.7)
    }
    
    // MARK: - CritterAnimatable
    
    func applyActiveStartState() {
        let p1 = CGPoint(x: 15.5, y: 24.6)
        let p2 = CGPoint(x: 14.9, y: 22.1)
        
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }
    
    func applyActiveEndState() {
        let p1 = CGPoint(x: 15.5, y: 24.6)
        let p2 = CGPoint(x: 14.9, y: 22.1)
        
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
