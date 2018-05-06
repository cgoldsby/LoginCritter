//
//  Mouth.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Mouth: UIImageView, CritterAnimatable {

    var isEcstatic = false

    private var isActive = false
    private let p1 = CGPoint(x: 13.7, y: 24.9)
    private let p2 = CGPoint(x: 14.3, y: 26.2)

    convenience init() {
        self.init(image: UIImage.Critter.mouthSmile)
        frame = CGRect(x: p1.x, y: p1.y, width: 30, height: 6.5)
    }
    
    // MARK: - CritterAnimatable

    func currentState() -> SavedState {
        let currentState = layer.transform

        return {
            self.layer.transform = currentState
            self.isActive = true
            self.applyEcstaticState()
        }
    }

    func applyInactiveState() {
        layer.transform = .identity

        isActive = false
        applyEcstaticState()
    }
    
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)

        isActive = true
        applyEcstaticState()
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }

    func applyEcstaticState() {
        if isEcstatic {
            layer.contents = UIImage.Critter.mouthFull.cgImage
            layer.bounds = CGRect(x: 0, y: 0, width: 26.6, height: 18.7)
        }
        else if isActive {
            layer.contents = UIImage.Critter.mouthHalf.cgImage
            layer.bounds = CGRect(x: 0, y: 0, width: 26.6, height: 13.7)
        }
        else {
            UIView.transition(with: self,
                              duration: 0.125,
                              options: .transitionCrossDissolve,
                              animations: { self.layer.contents = UIImage.Critter.mouthSmile.cgImage },
                              completion: nil)
            layer.bounds = CGRect(x: 0, y: 0, width: 30, height: 6.5)
        }
    }

    func applyPeekState() {
        layer.transform = CATransform3D
            .identity
            .translate(.y, by: 2.5)
        layer.contents = UIImage.Critter.mouthCircle.cgImage
        layer.bounds = CGRect(x: 0, y: 0, width: 14.3, height: 14.3)
    }

    func applyUnPeekState() {
        layer.transform = .identity
        applyEcstaticState()
    }
}
