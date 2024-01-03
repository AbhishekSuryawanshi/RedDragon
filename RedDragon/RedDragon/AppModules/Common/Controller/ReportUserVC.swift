//
//  ReportUserVC.swift
//  RedDragon
//
//  Created by iOS Dev on 03/01/2024.
//

import UIKit

class ReportUserVC: UIViewController {
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    var isFromBlockUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        if isFromBlockUser {
            controllerTitleLabel.text = "Block User".localized
            doneButton.setTitle("Block".localized, for: .normal)
        }else {
            controllerTitleLabel.text = "Report User".localized
            doneButton.setTitle("Report".localized, for: .normal)
        }
    }
}
