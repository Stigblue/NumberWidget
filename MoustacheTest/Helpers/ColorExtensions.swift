//
//  ColorExtensions.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    struct MyColors {
        static let gradientStart = UIColor(hex: 0x753F4F)
        static let gradientEnd = UIColor(hex: 0x221E33)
        static let sliderBackground = UIColor(hex: 0xFB986C)
        static let knob = UIColor(hex: 0xCA6C42)
        static let popupKnob = UIColor(hex: 0xFB986C)
        static let inactiveNumber = UIColor(hex: 0x59000000)
        static let activeNumber = UIColor(hex: 0xFFFFFF)
    }
}

