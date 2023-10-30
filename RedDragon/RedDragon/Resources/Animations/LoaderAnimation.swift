//
//  LoaderAnimation.swift
//  RedDragon
//
//  Created by QASR02 on 24/10/2023.
//

import UIKit
import NVActivityIndicatorView

class Loader {
    static let activityIndicator: NVActivityIndicatorView = {
        var centerX: CGFloat?
        var centerY: CGFloat?
        if Screen.screenX == nil {
            centerX = UIScreen.main.bounds.width / 2
            centerY = UIScreen.main.bounds.height / 2
        } else {
            centerX = Screen.screenX!
            centerY = Screen.screenY!
        }
        var AV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: NVActivityIndicatorType.lineScale, color: UIColor.gray, padding: 5)
        AV.layer.cornerRadius = 25
        AV.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        AV.center = CGPoint(x: centerX! , y: centerY! - 30)
        AV.backgroundColor = UIColor.clear
        return AV
    }()
}
