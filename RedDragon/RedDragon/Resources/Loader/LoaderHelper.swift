//
//  LoaderHelper.swift
//  RedDragon
//
//  Created by Qasr01 on 22/11/2023.
//

import UIKit
import Gifu

let activityViewSize: CGFloat = 60.0
var overLay: UIView = UIView()
var loaderGif: GIFImageView = GIFImageView()

var keyWindoww: UIWindow? {
    let allScenes = UIApplication.shared.connectedScenes
    for scene in allScenes {
        guard let windowScene = scene as? UIWindowScene else { continue }
        for window in windowScene.windows where window.isKeyWindow {
            return window
        }
    }
    return nil
}

extension UIViewController {
    func startLoader() {
        overLay.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        overLay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        (keyWindoww ?? self.view).addSubview(overLay)
        loaderGif.frame = CGRect(x: screenWidth/2-(activityViewSize/2),y: screenHeight/2-(activityViewSize/2), width: activityViewSize, height: activityViewSize)
        loaderGif.animate(withGIFNamed: "loader_1")
        loaderGif.startAnimatingGIF()
        overLay.addSubview(loaderGif)
    }
}

func stopLoader() {
    overLay.removeFromSuperview()
}
