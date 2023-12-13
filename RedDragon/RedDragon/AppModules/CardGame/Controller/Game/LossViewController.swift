//
//  LossViewController.swift
//  RedDragon
//
//  Created by QASR02 on 11/12/2023.
//

import UIKit
import Toast
import Combine

/// define protocol for delegate
protocol LossControllerDelegate: AnyObject {
    func controllerDismissedFrom_lossView()
}

class LossViewController: UIViewController {

    @IBOutlet weak var loseView: UIView!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    
    var budgetClass = BudgetCalculation()
    var matchStatus: UpdateMatchStatus?
    var cancellable = Set<AnyCancellable>()
    var opponentUserID: Int?
    var score: Int?
    var againstComputer: Bool = Bool()
    weak var delegate: LossControllerDelegate? ///declare delagate property

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        /// Notify the delegate
        self.delegate?.controllerDismissedFrom_lossView()
        dismiss(animated: true)
    }
}

extension LossViewController {
    func fetchViewModel() {
        matchStatus = UpdateMatchStatus()
        matchStatus?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        matchStatus?.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        matchStatus?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] message in
                UIView.transition(with: (self?.loseView)!, duration: 0.5, options: .transitionFlipFromTop) {
                    self?.loseView.alpha = 1
                }
            })
            .store(in: &cancellable)
    }
    
    func makeNetworkCall() {
        let userPreviousBudget = UserDefaults.standard.budget ?? 0
        let userScore = score ?? 0
        
        matchStatus?.yourMatchesAsyncCall(budget: userPreviousBudget, result: "LOSE", score: "\(userScore)", opponentUserID: opponentUserID ?? 0, againstComputer: againstComputer)
    }
}

extension LossViewController {
    
    private func loadFunctionality() {
        self.view.addSubview(Loader.activityIndicator)
        fetchViewModel()
        makeNetworkCall()
        loseView.alpha = 0
        checkLanguage()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func checkLanguage() {
        pointsEarnedLabel.text = StringConstants.pointsEarned.localized
        homeButton.setTitle(StringConstants.home.localized, for: .normal)
    }
}

