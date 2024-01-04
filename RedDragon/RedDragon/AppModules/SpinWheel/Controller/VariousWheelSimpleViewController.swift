//
//  VariousWheelSimpleViewController.swift
//  SwiftFortuneWheelDemoiOS
//
//  Created by Sherzod Khashimov on 7/10/20.
//  Copyright © 2020 Sherzod Khashimov. All rights reserved.
//

import UIKit
import SwiftFortuneWheel
import Combine

class VariousWheelSimpleViewController: UIViewController {
    
    @IBOutlet weak var btnRotate: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var centerView: UIView! {
        didSet {
            centerView.layer.cornerRadius = centerView.bounds.width / 2
            centerView.layer.borderColor = CGColor.init(srgbRed: CGFloat(256), green: CGFloat(256), blue: CGFloat(256), alpha: 1)
            centerView.layer.borderWidth = 7
        }
    }
    
    @IBOutlet weak var wheelControl: SwiftFortuneWheel! {
        didSet {
            wheelControl.configuration = .variousWheelSimpleConfiguration
            wheelControl.slices = slices
            wheelControl.pinImage = "whitePinArrow"
            
            wheelControl.pinImageViewCollisionEffect = CollisionEffect(force: 8, angle: 20)
            
            wheelControl.edgeCollisionDetectionOn = true
        }
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    var prizeInts = [30,10,250,20,0,5,500,80,0,200]
    var prizes = ["30🔥", "10🔥", "250🔥", "20🔥", "LOSE".localized, "5🔥", "500🔥", "80🔥", "LOSE".localized, "200🔥"]
    
    lazy var slices: [Slice] = {
        let slices = prizes.map({ Slice.init(contents: [Slice.ContentType.text(text: $0, preferences: .variousWheelSimpleText)]) })
        return slices
    }()

    var finishIndex: Int {
        return Int.random(in: 0..<wheelControl.slices.count-1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModels()
        setupLocalisation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerView.layer.cornerRadius = centerView.bounds.width / 2
    }
    
    func setupLocalisation(){
        lblTitle.text = "Spin Wheel".localized
        btnRotate.setTitle("Rotate".localized, for: .normal)
    }
    
    @IBAction func rotateTap(_ sender: Any) {
        let selectedIndex = finishIndex
        wheelControl.startRotationAnimation(finishIndex: selectedIndex, continuousRotationTime: 1) { (finished) in
            print(finished)
            print(selectedIndex)
            print(self.prizes[selectedIndex])
            if self.prizeInts[selectedIndex] == 0{
                self.failureAlert()
            }
            else{
                self.savePoints(points: self.prizeInts[selectedIndex])
            }
        }
    }
    
    func failureAlert(){
        self.customAlertView(title: "Sorry!!".localized, description: "Better try next time".localized, image: ImageConstants.alertImage) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func savePoints(points:Int){
        let param:[String:Any] = ["coin_count":points,
                                  "type":"c",
                                  "event":"Spin Wheel"]
        AddWalletVM.shared.addTransaction(parameters: param)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    func setupViewModels(){
        AddWalletVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        AddWalletVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        AddWalletVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                
                
                if let dataResponse = response?.response {
                    var user = UserDefaults.standard.user
                    user?.wallet = dataResponse.data?.userwallet ?? 0
                    UserDefaults.standard.user = user
                    self?.successAddPoints(message: dataResponse.messages?.first ?? "Points Saved".localized)
                    
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
    }
    
    
    func successAddPoints(message:String){
        self.customAlertView(title: ErrorMessage.success.localized, description: message, image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
