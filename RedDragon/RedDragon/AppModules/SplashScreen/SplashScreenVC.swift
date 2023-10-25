//
//  SplashScreenVC.swift
//  RedDragon
//
//  Created by QASR02 on 24/10/2023.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    func loadFunctionality() {
        let textAnimator = ViewAnimator(anyView: titleLabel)
        textAnimator.animate(initialScale: 0.001, finalScale: 2.5, duration: 0.4)
        redirectToViewController()
    }
    
    func redirectToViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabView") as? UITabBarController
            //self.present(vc!, animated: true)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }


}
