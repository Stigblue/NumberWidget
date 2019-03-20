//
//  SliderViewModel.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit

class SliderViewModel {
    
    var customSliderLength: Int = 0 
    var widthCoverageForNumber: CGFloat = 0
    
    func setupSliderWith(customLength: Int) -> [UILabel] {
        var labelArray = [UILabel]()
        self.customSliderLength = customLength
        let deviceWidth = UIScreen.main.bounds.width - 32 // 32 being constraint width to edges
        self.widthCoverageForNumber = deviceWidth / CGFloat(customLength)
        for i in 0...customLength {
            let label = self.setupLabel()
            label.text = "\(i + 1)"
            let customXPos = CGFloat(i) * self.widthCoverageForNumber
            label.frame = CGRect(x: customXPos, y: 0, width: self.widthCoverageForNumber, height: 50)
            
            if i == 0 {
                label.textColor = UIColor.MyColors.activeNumber
                label.alpha = 1
            }
            labelArray.append(label)
        }
        print("CustomLength is: \(customLength), widthForNumber is: \(self.widthCoverageForNumber)")
        return labelArray
    }
    
    
    func setupLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        if let font = UIFont(name: "OpenSans-Regular", size: 21) {
            label.font = font
        } else if let font = UIFont(name: "OpenSans-Bold", size: 21) {
            print("Cannot find regular font, using Bold instead")
            label.font = font
        } else {
            print("Cannot find any fonts, using system font instead")
            label.font = UIFont.boldSystemFont(ofSize: 21)
        }
        label.textColor = UIColor.MyColors.inactiveNumber
        label.alpha = 0.3
        return label
    }
    
    
    func getIndexFor(xValueRange: CGFloat) -> Int {
        var matchingIndex = Int(xValueRange) / Int(self.widthCoverageForNumber)
        if matchingIndex == self.customSliderLength {
            matchingIndex = matchingIndex - 1
        }
        return matchingIndex
    }
    
    func calcCustomLengthExtraKnobWidth() -> CGFloat{
        switch self.customSliderLength {
        case 9: return -4
        case 8: return -2
        case 7: return +1
        case 6: return +6
        case 5: return +11
        case 4: return +19
        case 3: return +33
        case 2: return +62
        case 1: return +148
        default: return 0;
        }
    }
    
}
