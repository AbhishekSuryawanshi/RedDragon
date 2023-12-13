//
//  WinViewController.swift
//  RedDragon
//
//  Created by QASR02 on 11/12/2023.
//

import UIKit
import Toast
import Combine
import SPConfetti

/// define protocol for delegate
protocol WinControllerDelegate: AnyObject {
    func controllerDismissedFrom_winView()
}

class WinViewController: UIViewController {
    
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    
    var budgetClass = BudgetCalculation()
    var updateInfoVM = UpdateInfoViewModel()
    var matchStatus: UpdateMatchStatus?
    var cancellable = Set<AnyCancellable>()
    var winningBonous: Int?
    var score: Int?
    var opponentUserID: Int?
    var againstComputer: Bool = Bool()
    weak var delegate: WinControllerDelegate? ///declare delagate property

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        /// Notify the delegate
        self.delegate?.controllerDismissedFrom_winView()
        dismiss(animated: true)
    }
}

extension WinViewController {
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
                UIView.transition(with: (self?.winView)!, duration: 0.5, options: .transitionFlipFromTop) {
                    self?.winView.alpha = 1
                    SPConfetti.startAnimating(.fullWidthToUp, particles: [.triangle, .arc, .star], duration: 0.5)
                }
            })
            .store(in: &cancellable)
    }
    
    func makeNetworkCall_toSendMatchStatus() {
        let budget = calculateBudget(20000000) //20M winning bonus
        UserDefaults.standard.budget = Int(budget)
        
        let userNewScore = score ?? 0
        
        matchStatus?.yourMatchesAsyncCall(budget: Int(budget), result: "WIN", score: "\(userNewScore)", opponentUserID: opponentUserID ?? 0, againstComputer: againstComputer)
    }
    
    ///make network call to update user budget
    func makeNetworkCall_toUpdateScore() {
        let userPreviusScore = UserDefaults.standard.score ?? 0
        let newScore = (score ?? 0) + userPreviusScore
        UserDefaults.standard.score = newScore
        updateInfoVM.updateScoreAsyncCall(score: newScore)
    }
}

extension WinViewController {
    
    private func loadFunctionality() {
        self.view.addSubview(Loader.activityIndicator)
        fetchViewModel()
        makeNetworkCall_toSendMatchStatus()
        makeNetworkCall_toUpdateScore()
        winView.alpha = 0
        checkLanguage()
    }
    
    func checkLanguage() {
        pointsEarnedLabel.text = StringConstants.pointsEarned.localized
        homeButton.setTitle(StringConstants.home.localized, for: .normal)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    ///calculate user budget after selling player
    func calculateBudget(_ playerValue: Double) -> Double {
        let userBudget = UserDefaults.standard.budget ?? 0
        let userFinalBudget = budgetClass.performOperation(Double(userBudget), playerValue, operation: +)
        return userFinalBudget
    }
}
