//
//  Navigation.swift
//  RedDragon
//
//  Created by QASR02 on 24/10/2023.
//

import UIKit
import Hero

extension UIViewController {
    
    private func configureViewControllerAnimation<T: UIViewController>(_ viewController: T, animationType: HeroDefaultAnimationType, configure: ((T) -> Void)?) {
        viewController.hero.isEnabled = true
        viewController.hero.modalAnimationType = animationType
        configure?(viewController)
    }
    
    public func presentToStoryboard(_ storyboardName: String, identifier: String? = nil, animationType: HeroDefaultAnimationType = .zoomOut) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc!.hero.isEnabled = true
        vc!.hero.modalAnimationType = animationType
        present(vc!, animated: true)
    }
    
    public func presentToViewController<T: UIViewController>(_ viewController: T.Type, storyboardName: String = "Main", identifier: String? = nil, animationType: HeroDefaultAnimationType = .zoomOut, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier ?? String(describing: viewController)) as! T
        configureViewControllerAnimation(vc, animationType: animationType, configure: configure)
        present(vc, animated: true)
    }
    
    public func navigateToViewController<T: UIViewController>(_ viewController: T.Type, storyboardName: String = "Main", identifier: String? = nil, animationType: HeroDefaultAnimationType = .zoomOut, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier ?? String(describing: viewController)) as! T
        configureViewControllerAnimation(vc, animationType: animationType, configure: configure)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


/*
 //.autoReverse(presenting: .pageIn(direction: .left))
 //.pageOut(direction: .down)
 //.uncover(direction: .down)
 //.fade
 //.zoomSlide(direction: .up)
 //.pull(direction: .left)
 //.pageIn(direction: .left)
 //.autoReverse(presenting: .pageIn(direction: .left))
 //.zoom
 //.selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
 */
