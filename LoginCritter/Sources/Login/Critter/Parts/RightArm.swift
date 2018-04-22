//
//  RightAmr.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/22/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class RightArm: UIImageView {

    convenience init() {
        self.init(image: UIImage.Critter.rightArm)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }

        let originY = superview.bounds.maxY
        frame = CGRect(x: 92.6, y: originY, width: 42.3, height: 82.6)
    }
}
