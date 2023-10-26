//
//  CustomAlertVC.swift
//  RedDragon
//
//  Created by QASR02 on 25/10/2023.
//

import UIKit

protocol CustomAlertDelegate: AnyObject {
    func dismissCustomAlert()
}

class CustomAlertVC: UIViewController {

    @IBOutlet weak var alertView: UIVisualEffectView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    weak var delegate: CustomAlertDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShadow(alertView, color: UIColor.lightGray, opacity: 1.0)
        alertTitleLabel.text = UserDefaults.standard.string(forKey: UserDefaultString.title)
        descriptionLabel.text = UserDefaults.standard.string(forKey: UserDefaultString.description)
        dismissButton.setTitle(StringConstants.dismiss.localized, for: .normal)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultString.title)
        UserDefaults.standard.removeObject(forKey: UserDefaultString.description)
        dismiss(animated: true)
        delegate?.dismissCustomAlert()
    }

}
