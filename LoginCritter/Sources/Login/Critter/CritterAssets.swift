//
//  CritterAssets.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit


extension UIImage {

    struct Critter {
        static let body = #imageLiteral(resourceName: "Body")
        static let doeEye = #imageLiteral(resourceName: "Eye-doe")
        static let eye = #imageLiteral(resourceName: "Eye")
        static let head = #imageLiteral(resourceName: "Head")
        static let mouthOpen = #imageLiteral(resourceName: "Mouth-open")
        static let muzzle = #imageLiteral(resourceName: "Muzzle")
        static let nose = #imageLiteral(resourceName: "Nose")
        static let leftEar = #imageLiteral(resourceName: "Ear")
        static let rightEar: UIImage = {
            let leftEar = UIImage.Critter.leftEar
            return UIImage(
                cgImage: leftEar.cgImage!,
                scale: leftEar.scale,
                orientation: .upMirrored
            )
        }()
    }
}
