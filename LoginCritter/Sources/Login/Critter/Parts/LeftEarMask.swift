//
//  LeftEarMask.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class LeftEarMask: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.head)
        layer.anchorPoint = CGPoint(x: 1, y: 0)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }

        frame = superview.bounds
        mask = {
            let mask = UIView()
            mask.backgroundColor = .black
            var frame = superview.bounds
            frame.size.width = frame.width / 2
            mask.frame = frame
            return mask
        }()
    }
    
    // MARK: - CritterAnimatable

    func applyActiveStartState() {
        layer.transform = .identity
    }

    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .scale(.x, by: 0.82)
    }
}
