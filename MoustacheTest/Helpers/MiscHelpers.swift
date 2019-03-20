//
//  MiscHelpers.swift
//  MoustacheTest
//
//  Created by Stig von der Ahé on 17/03/2019.
//  Copyright © 2019 Stig von der Ahé. All rights reserved.
//

import UIKit

class MiscHelpers {
    
    static func impactGeneratorActivated(){
        if #available(iOS 10.0, *) {
            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
            impactGenerator.prepare()
            impactGenerator.impactOccurred()
        }
    }
    
    static func animateLabel(_ label: UILabel){
        UIView.animate(withDuration: 0.5, animations: {
            label.alpha = 1
        }) { (completed) in
            UIView.animate(withDuration: 1, animations: {
                label.alpha = 0
            })
        }
    }
}

extension NSObject {
    public func delayForSeconds(delay: Double, completion: @escaping() -> ()) {
        let timer = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: timer) {
            completion()
        }
    }
}
