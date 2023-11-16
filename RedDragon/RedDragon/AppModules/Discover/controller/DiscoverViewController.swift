//
//  DiscoverViewController.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit

class DiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

     @IBAction func btnGoToBets(_ sender: Any) {
    
         self.goToBets()
     }
    
    
    func goToBets(){        
        navigateToViewController(BetHomeVc.self, storyboardName: StoryboardName.bets, animationType: .autoReverse(presenting: .zoom))
    }
     
}
