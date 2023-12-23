//
//  EditProfileVC.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textEntryView: UIView!
    @IBOutlet weak var phoneView: UIView!
    
    var profileType: ProfileType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func initialSettings() {
        phoneView.isHidden = profileType == .phone
    }
    
    // MARK: - Button Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
}
