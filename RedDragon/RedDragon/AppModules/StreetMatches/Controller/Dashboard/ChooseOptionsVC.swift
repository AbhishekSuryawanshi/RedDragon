//
//  ChooseOptionsVC.swift
//  RedDragon
//
//  Created by Remya on 11/29/23.
//

import UIKit

class ChooseOptionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func actionTapCreateStadium(_ sender: Any) {
         let nav = self.presentingViewController as? UINavigationController
        let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "CreateStadiumVC")
        nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
