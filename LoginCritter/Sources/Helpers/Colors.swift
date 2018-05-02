//
//  Colors.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

private enum ColorPalette: String {
    case light
    case dark
    case text
}

extension UIColor {
    static let light = #colorLiteral(red: 0.768627451, green: 1, blue: 0.9764705882, alpha: 1)
    static let dark = #colorLiteral(red: 0.02745098039, green: 0.7450980392, blue: 0.7215686275, alpha: 1)
    static let text = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)

    // MARK: - Private

    private convenience init?(named color: ColorPalette) {
        self.init(named: color.rawValue)
    }
}
