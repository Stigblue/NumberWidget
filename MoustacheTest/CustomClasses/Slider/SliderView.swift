//
//  SliderView.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit

protocol SliderViewDelegate {
    func didSelectNumber(_ number: String)
}

class SliderView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var popupKnob: UIView!
    @IBOutlet weak var popupKnobInactiveYConstraint: NSLayoutConstraint! // priority 999 (to activate the knob, set constraint to 1)
    @IBOutlet weak var popupKnobXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var popupLabel: UILabel!
    
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var sliderStackView: UIStackView!
    
    @IBOutlet weak var knob: UIView!
    @IBOutlet weak var knobXConstraint: NSLayoutConstraint!
    
    var selectedNumberLabel: UILabel?
    let sliderVM = SliderViewModel()
    
    var delegate: SliderViewDelegate?
    var panGesture = UIPanGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    
    
    
    // MARK: Setup
    func setupSliderWith(customLength: Int, sliderColor: UIColor) {
        self.setupGestures()
        let labelArray = self.sliderVM.setupSliderWith(customLength: customLength)
        for label in labelArray {
            if label == labelArray.first {
                self.selectedNumberLabel = label
            }
            self.sliderStackView.addSubview(label)
        }
        self.knobXConstraint.constant = self.sliderVM.calcCustomLengthExtraKnobWidth() // set the correct knobPosition for the specific slider configuration
        self.applyStyling(sliderColor: sliderColor)
    }
    
    func applyStyling(sliderColor: UIColor){
        self.popupKnob.frame = self.bounds
        self.popupKnob.layer.cornerRadius = 23
        self.popupLabel.textColor = UIColor.MyColors.activeNumber
        
        self.sliderContainerView.layer.cornerRadius = 25
        self.sliderContainerView.clipsToBounds = true
        self.sliderContainerView.backgroundColor = sliderColor
        
        self.knob.layer.cornerRadius = self.knob.frame.width / 2
        self.knob.backgroundColor = UIColor.MyColors.knob
    }
    
    func setupGestures(){
        self.panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.pan))
        self.panGesture.delegate = self
        self.sliderContainerView.addGestureRecognizer(self.panGesture)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.tap))
        self.tapGesture.delegate = self
        self.sliderContainerView.addGestureRecognizer(self.tapGesture)
    }
    
    static func instantiateSliderView(withFrame: CGRect) -> SliderView {
        let sliderCustomView = UINib(nibName: "SliderView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! SliderView
        sliderCustomView.frame = withFrame
        return sliderCustomView
    }
    
    
    
    // MARK: Gestures
    var popupKnobWasMoved: Bool = false
    var willHidePopupKnob: Bool = false
    var previousSelectedIndex: Int = 0
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        let viewOfTouches = self.sliderContainerView
        let extraXValue: CGFloat = 32
        let locationX = gesture.location(in: viewOfTouches).x
        let matchingIndex = self.sliderVM.getIndexFor(xValueRange: locationX)
        
        // show the popupKnob whenever panned
        if !self.popupKnobVisible {
            self.animatePopupKnob(visible: true, onboardingMode: false)
        }
        
        self.popupKnobWasMoved = true
        self.handleKnobLabelUpdate(matchingIndex: matchingIndex)
        
        if matchingIndex == previousSelectedIndex && gesture.state != .ended { // let the .ended state fall through in the end
            self.knobXConstraint.constant = locationX - extraXValue
            self.popupKnobXConstraint.constant = locationX - extraXValue
            return
        }
        
        previousSelectedIndex = matchingIndex
        
        switch gesture.state {
        case .changed:
            self.knobXConstraint.constant = locationX - extraXValue
            self.popupKnobXConstraint.constant = locationX - extraXValue
            
        case .ended:
            self.movePopupKnob(toXValue: locationX)
            self.moveKnob(toXValue: locationX, withAnimation: true, onboardingMode: false)
            
            if self.willHidePopupKnob {
                return
            }
            
            self.willHidePopupKnob = true
            self.popupKnobWasMoved = false
            
            // After the specified seconds, if the widget was panned, the popupKnob has been moved and will not hide itself, else it will hide itself
            self.delayForSeconds(delay: 0.2) {
                if self.popupKnobWasMoved {
                    self.willHidePopupKnob = false
                    return
                }
                
                self.animatePopupKnob(visible: false, onboardingMode: false)
                self.willHidePopupKnob = false
            }
        default: break;
        }
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        let viewOfTouches = self.sliderContainerView
        let locationX = gesture.location(in: viewOfTouches).x
        let matchingIndex = self.sliderVM.getIndexFor(xValueRange: locationX)
        self.handleKnobLabelUpdate(matchingIndex: matchingIndex)
        
        if matchingIndex == previousSelectedIndex && gesture.state != .ended  {
            self.movePopupKnob(toXValue: locationX)
            self.moveKnob(toXValue: locationX, withAnimation: true, onboardingMode: false)
            return
        }
        previousSelectedIndex = matchingIndex
        self.animatePopupKnob(visible: true, onboardingMode: false)
        self.movePopupKnob(toXValue: locationX)
        self.moveKnob(toXValue: locationX, withAnimation: true, onboardingMode: false)
        
        switch gesture.state {
        case .ended:
            self.delayForSeconds(delay: 0.6) {
                self.animatePopupKnob(visible: false, onboardingMode: false)
            }
        default: break;
        }
    }

    
    
    // MARK: Animation and movement og Knob and PopupKnob
    var popupKnobVisible: Bool = false
    func animatePopupKnob(visible: Bool, onboardingMode: Bool) {
        if !onboardingMode {
            if (visible && popupKnobVisible) || (!visible && !popupKnobVisible) {return}
        }
        
        var springWithDamping: CGFloat
        if visible {
            springWithDamping = 0.6
        } else {
            springWithDamping = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
            if visible {
                self.popupKnobVisible = true
                self.popupKnobInactiveYConstraint.priority = UILayoutPriority(1)
                MiscHelpers.impactGeneratorActivated()
            } else {
                self.popupKnobVisible = false
                self.popupKnobInactiveYConstraint.priority = UILayoutPriority(999)
                self.delegate?.didSelectNumber("\(self.selectedNumberLabel?.text ?? "nil")")
            }
            self.layoutIfNeeded()
        })
    }
    
    func movePopupKnob(toXValue: CGFloat) {
        let matchingIndex = self.sliderVM.getIndexFor(xValueRange: toXValue)
        self.popupKnobXConstraint.constant = self.sliderVM.widthCoverageForNumber * CGFloat(matchingIndex) + self.sliderVM.calcCustomLengthExtraKnobWidth()
        self.layoutIfNeeded()
    }
    
    func moveKnob(toXValue: CGFloat, withAnimation: Bool, onboardingMode: Bool){
        let matchingIndex = self.sliderVM.getIndexFor(xValueRange: toXValue)
        
        if withAnimation {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.knobXConstraint.constant = (self.sliderVM.widthCoverageForNumber * CGFloat(matchingIndex)) + self.sliderVM.calcCustomLengthExtraKnobWidth()
                if onboardingMode {
                    self.movePopupKnob(toXValue: toXValue)
                }
                print(self.knobXConstraint.constant)
                self.layoutIfNeeded()
            })
            
            if onboardingMode {
                self.handleKnobLabelUpdate(matchingIndex: matchingIndex)
            }
            
        } else {
            self.knobXConstraint.constant = (self.sliderVM.widthCoverageForNumber * CGFloat(matchingIndex)) + self.sliderVM.calcCustomLengthExtraKnobWidth()
            self.layoutIfNeeded()
        }
    }
    
    //MARK: Updating of labels and colors based of knob movement
    func handleKnobLabelUpdate(matchingIndex: Int){
        let newIndex: Int
        if matchingIndex >= self.sliderVM.customSliderLength {
            newIndex = self.sliderVM.customSliderLength
        } else {
            newIndex = matchingIndex + 1
        }
        
        if let previousLabel = self.selectedNumberLabel {
            previousLabel.alpha = 0.3
            previousLabel.textColor = UIColor.MyColors.inactiveNumber
        }
        
        let label = self.sliderStackView.subviews[newIndex - 1] as! UILabel
        label.textColor = UIColor.MyColors.activeNumber
        label.alpha = 1
        self.selectedNumberLabel = label
        self.popupLabel.text = "\(newIndex)"
    }

    
    // Onboarding Animation 
    func animateOnboardingLeet(){
        self.isUserInteractionEnabled = false
        let sliderValueRange = (self.sliderVM.widthCoverageForNumber * 1)
        
        delayForSeconds(delay: 1) {
            self.animatePopupKnob(visible: true, onboardingMode: true)
        }
        
        delayForSeconds(delay: 1.5) {
            self.animatePopupKnob(visible: false, onboardingMode: true)
        }
        
        delayForSeconds(delay: 2) {
            self.moveKnob(toXValue: (sliderValueRange * 3) - self.sliderVM.widthCoverageForNumber, withAnimation: true, onboardingMode: true)
        }
        
        delayForSeconds(delay: 2.5) {
            self.animatePopupKnob(visible: true, onboardingMode: true)
        }
        
        delayForSeconds(delay: 3) {
            self.animatePopupKnob(visible: false, onboardingMode: true)
        }
        
        delayForSeconds(delay: 3.5) {
            self.animatePopupKnob(visible: true, onboardingMode: true)
        }
        
        delayForSeconds(delay: 4) {
            self.animatePopupKnob(visible: false, onboardingMode: true)
        }
        
        delayForSeconds(delay: 4.5) {
            self.moveKnob(toXValue: (sliderValueRange * 7) - self.sliderVM.widthCoverageForNumber, withAnimation: true, onboardingMode: true)
        }
        
        delayForSeconds(delay: 5) {
            self.animatePopupKnob(visible: true, onboardingMode: true)
        }
        
        delayForSeconds(delay: 5.8) {
            self.animatePopupKnob(visible: false, onboardingMode: true)
        }
        
        delayForSeconds(delay: 7.5) {
            self.moveKnob(toXValue: (sliderValueRange * 1) - self.sliderVM.widthCoverageForNumber, withAnimation: true, onboardingMode: true)
            self.isUserInteractionEnabled = true
        }
    }
    
    
}
