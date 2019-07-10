//
//  CritterAssets.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

struct FrameworkImageLiteral: _ExpressibleByImageLiteral {
    
    let image: UIImage
    init(imageLiteralResourceName path: String) {
        let bundle = Bundle(for: LoginViewController.self)
        self.image = UIImage(named: path, in: bundle, compatibleWith: nil)!
    }
}

extension UIImage {

    struct Critter {
        static let body = (#imageLiteral(resourceName: "Body") as FrameworkImageLiteral).image
        static let doeEye = (#imageLiteral(resourceName: "Eye-doe") as FrameworkImageLiteral).image
        static let eye = (#imageLiteral(resourceName: "Eye") as FrameworkImageLiteral).image
        static let head = (#imageLiteral(resourceName: "Head") as FrameworkImageLiteral).image
        static let leftArm = (#imageLiteral(resourceName: "Arm") as FrameworkImageLiteral).image
        static let leftEar = (#imageLiteral(resourceName: "Ear") as FrameworkImageLiteral).image
        static let mouthCircle = (#imageLiteral(resourceName: "Mouth-circle") as FrameworkImageLiteral).image
        static let mouthFull = (#imageLiteral(resourceName: "Mouth-full") as FrameworkImageLiteral).image
        static let mouthHalf = (#imageLiteral(resourceName: "Mouth-half") as FrameworkImageLiteral).image
        static let mouthSmile = (#imageLiteral(resourceName: "Mouth-smile") as FrameworkImageLiteral).image
        static let muzzle = (#imageLiteral(resourceName: "Muzzle") as FrameworkImageLiteral).image
        static let nose = (#imageLiteral(resourceName: "Nose") as FrameworkImageLiteral).image
        static let rightEar: UIImage = {
            let leftEar = UIImage.Critter.leftEar
            return UIImage(
                cgImage: leftEar.cgImage!,
                scale: leftEar.scale,
                orientation: .upMirrored
            )
        }()
        static let rightArm: UIImage = {
            let leftArm = UIImage.Critter.leftArm
            return UIImage(
                cgImage: leftArm.cgImage!,
                scale: leftArm.scale,
                orientation: .upMirrored
            )
        }()
    }
}
