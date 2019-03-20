//
//  ViewController.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var sliderView: SliderView!
    @IBOutlet weak var sequenceLabel: UILabel!
    
    var sequenceNumbers: String = "" {
        didSet {
            if sequenceNumbers.contains("1337") {
                print("LEET")
                self.sequenceNumbers = "LEET"
                self.delayForSeconds(delay: 2) {
                    self.sequenceNumbers = ""
                }
            }
            self.sequenceLabel.text = sequenceNumbers
            MiscHelpers.animateLabel(self.sequenceLabel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientView.setupGradient(startColor: UIColor.MyColors.gradientStart, endColor: UIColor.MyColors.gradientEnd, startAlpha: 1, endAlpha: 1)
        self.setupSliderView()
        self.gradientView.addSubview(sequenceLabel)
    }
    
    func setupSliderView(){
        self.sliderView = SliderView.instantiateSliderView(withFrame: sliderView.frame)
        self.gradientView.addSubview(self.sliderView)
        self.sliderView.delegate = self
        self.sliderView.setupSliderWith(customLength: 8, sliderColor: UIColor.MyColors.sliderBackground)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sliderView.animateOnboardingLeet()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension ViewController: SliderViewDelegate {
    func didSelectNumber(_ number: String) {
        print("Selected number: " + number)
        self.sequenceNumbers = "\(self.sequenceNumbers as Any)" + number
    }
}



