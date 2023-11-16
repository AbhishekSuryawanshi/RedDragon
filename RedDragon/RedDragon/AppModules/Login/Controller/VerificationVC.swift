//
//  VerificationVC.swift
//  RedDragon
//
//  Created by Qasr01 on 14/11/2023.
//

import UIKit

class VerificationVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        ///Add top corner for background view
        bgView.roundCornersWithBorderLayer(cornerRadii: 30, corners: [.topLeft, .topRight], bound: bgView.bounds)
        bgView.applyShadow(radius: 10, opacity: 1)
    }
    
    func initialSettings() {
        topTextLabel.text = "A verification code has been sent \nto your mobile number"
        let bottomFormatedText = NSMutableAttributedString()
        bottomFormatedText.regular("Didn’t receive the code? ", size: 15).bold("Resend", size: 15)
        bottomFormatedText.addUnderLine(textToFind: "Resend")
        bottomFormatedText.addLink(textToFind: "Resend", linkURL: "resend")
        bottomTextView.attributedText = bottomFormatedText
        
    }

    // MARK: - Button Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
    }
}

//MARK: UITextView Delegates
extension VerificationVC: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "resend":
            print("resend preeeeee")
        default:
            print("")
        }
        return false
    }
}
