//
//  Navigation.swift
//  RedDragon
//
//  Created by QASR02 on 24/10/2023.
//

import UIKit
import Hero

extension UIViewController {
    
    @IBAction func backClicked(_ sender: Any) {
        if self.isBeingPresented || self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
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
    
    public func presentOverViewController<T: UIViewController>(_ viewController: T.Type, storyboardName: String = "Main", identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier ?? String(describing: viewController)) as! T
        vc.modalPresentationStyle = .overCurrentContext
        configure?(vc)
        present(vc, animated: true)
    }
    
    public func navigateToViewController<T: UIViewController>(_ viewController: T.Type, storyboardName: String = "Main", identifier: String? = nil, animationType: HeroDefaultAnimationType = .zoomOut, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier ?? String(describing: viewController)) as! T
        configureViewControllerAnimation(vc, animationType: animationType, configure: configure)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func navigateToXIBViewController<T: UIViewController>(_ viewController: T.Type, nibName: String, animationType: HeroDefaultAnimationType = .zoomOut, configure: ((T) -> Void)? = nil) {
        
        let vc = viewController.init(nibName: nibName, bundle: nil)
        configureViewControllerAnimation(vc, animationType: animationType, configure: configure)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: above functions can be use like:--
///presentToStoryboard(Storyboard.play, animationType: .fade)
//////presentToViewController(SoccerClubVC.self, storyboardName: Storyboard.menu, animationType: .autoReverse(presenting: .zoom))
///navigateToViewController(FavoritePlayerVC.self, storyboardName: Storyboard.main, animationType: .autoReverse(presenting: .zoom))


//MARK: Other animations
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
