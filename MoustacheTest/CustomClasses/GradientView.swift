//
//  GradientView.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit

class GradientView: UIView {
    let gradient = CAGradientLayer()

    func setupGradient(startColor: UIColor, endColor: UIColor, startAlpha: CGFloat, endAlpha: CGFloat) {
        self.gradient.frame = self.bounds
        self.gradient.colors = [startColor.withAlphaComponent(startAlpha).cgColor, endColor.withAlphaComponent(endAlpha).cgColor]
        self.gradient.locations = [0, 1]
        self.gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        self.gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.bounds
        self.gradient.setNeedsLayout()
    }
}
