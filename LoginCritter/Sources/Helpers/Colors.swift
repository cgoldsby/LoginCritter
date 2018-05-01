//
//  Colors.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

extension UIColor {


    class var light: UIColor {
        return UIColor(named: "light") ?? #colorLiteral(red: 0.768627451, green: 1, blue: 0.9764705882, alpha: 1)
    }

    class var dark: UIColor {
        return UIColor(named: "dark") ?? #colorLiteral(red: 0.02745098039, green: 0.7450980392, blue: 0.7215686275, alpha: 1)
    }

    class var text: UIColor {
        return UIColor(named: "text") ?? #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
    }

}

