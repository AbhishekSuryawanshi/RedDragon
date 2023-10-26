//
//  ZoomAnimation.swift
//  RedDragon
//
//  Created by QASR02 on 24/10/2023.
//

import UIKit

class ViewAnimator<T: UIView> {
    private let anyView: T
    
    init(anyView: T) {
        self.anyView = anyView
    }
    
    func animate(initialScale: CGFloat, finalScale: CGFloat, duration: TimeInterval) {
        anyView.transform = CGAffineTransform.identity.scaledBy(x: initialScale, y: initialScale)
        UIView.animate(withDuration: duration / 1.5, animations: {
            self.anyView.transform = CGAffineTransform.identity.scaledBy(x: finalScale, y: finalScale)
        }) { finished in
            UIView.animate(withDuration: duration / 2, animations: {
                self.anyView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }) { finished in
                UIView.animate(withDuration: duration / 2, animations: {
                    self.anyView.transform = CGAffineTransform.identity
                })
            }
        }
    }    
}
