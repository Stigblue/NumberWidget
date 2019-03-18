//
//  SliderView.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit

class SliderView: UIView {
    
    // Make a VM for this class
    
    @IBOutlet weak var popupKnob: UIView!
    @IBOutlet weak var popupKnobInactiveYConstraint: NSLayoutConstraint! // priority 999 (to activate the knob, set constraint to 1)
    
    
    @IBOutlet weak var popupLabel: UILabel!
    
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var sliderStackView: UIStackView!
    
    
    var customLength: Int = 0
    var widthForNumber: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.applyStyling()
        self.setupWith(customLength: 8)
    }
    
    // put in ViewModel
    func setupWith(customLength: Int){
        self.customLength = customLength
        let deviceWidth = UIScreen.main.bounds.width - 32 // 32 being constraint width to edges
        self.widthForNumber = deviceWidth / CGFloat(customLength)
        for i in 0...customLength {
            let label = setupLabel()
            label.text = "\(i + 1)"
            let customXPos = CGFloat(i) * self.widthForNumber
            label.frame = CGRect(x: customXPos, y: 0, width: widthForNumber, height: 50)
            sliderStackView.addSubview(label)
        }
        print("CustomLength is: \(customLength), widthForNumber is: \(widthForNumber)")
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
        //                    UIFont.familyNames.forEach({ familyName in
        //                        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        //                        print(familyName, fontNames)
        //                    })
        return label
    }
    
    
    func animateKnob(visible: Bool) {
        var springWithDamping: CGFloat
        if visible {
            springWithDamping = 0.6
        } else {
            springWithDamping = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
            if visible {
                self.popupKnobInactiveYConstraint.priority = UILayoutPriority(1)
            } else {
                self.popupKnobInactiveYConstraint.priority = UILayoutPriority(999)
            }
            self.layoutIfNeeded()
        })
    }
    
    func applyStyling(){
        self.popupKnob.frame = self.bounds
        self.popupKnob.layer.cornerRadius = 25
        self.popupLabel.textColor = UIColor.MyColors.activeNumber
        
        self.sliderContainerView.layer.cornerRadius = 26
        self.sliderContainerView.clipsToBounds = true
        self.sliderContainerView.backgroundColor = UIColor.MyColors.sliderBackground
    }
    
    
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.popupKnob.frame = self.bounds
//        self.popupKnob.setNeedsLayout()
//
//        self.sliderContainerView.frame = self.bounds
//        self.sliderContainerView.setNeedsLayout()
//
//    }
    
    
    
}
