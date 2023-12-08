//
//  BuyPlayerViewController.swift
//  RedDragon
//
//  Created by QASR02 on 06/12/2023.
//

import UIKit
import Hero
import Toast
import Combine
import SDWebImage

/// define protocol for delegate
protocol ControllerDelegate: AnyObject {
    func controllerDismissed()
}

class BuyPlayerViewController: UIViewController {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var positionNameLabel: UILabel!
    @IBOutlet weak var marketValueLabel: UILabel!
    @IBOutlet weak var currentBudgetLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var image:      String? = ""
    var name:       String? = ""
    var position:   String? = ""
    var value:      String? = ""
    var slug:       String? = ""
    var playerID:   String? = ""
    var myTeam:     [Int] = []
    
    var cancellable = Set<AnyCancellable>()
    var teamListVM: MyTeamViewModel?
    var buyPlayerVM: BuyPlayerViewModel?
    var budgetClass = BudgetCalculation()
    var updateInfoVM = UpdateInfoViewModel()
    weak var delegate: ControllerDelegate? ///declare delagate property

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        fetchMyTeamViewModel()
        fetchBoughtPlayerDetails()
        checkLocalisation()
    }
    
    @IBAction func buyButton(_ sender: Any) {
        guard let playerIDString = playerID,
              let specificPlayerID = Int(playerIDString) else {
            print("Invalid player ID")
            return
        }
        if myTeam.contains(specificPlayerID) {
            self.view.makeToast(ErrorMessage.playerAlreadyUsed.localized, duration: 2.0, position: .center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.dismiss(animated: true)
            }
        } else {
            ///check user budget first, before buying player
            checkUserBudget()
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

/// __Fetch View model data
extension BuyPlayerViewController {
    
    private func fetchMyTeamViewModel() {
        teamListVM = MyTeamViewModel()
        teamListVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.error.localized, description: error, image: ImageConstants.alertImage)
        }
        teamListVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        teamListVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] team in
                guard let data = team else {
                    return
                }
                self?.storePlayerID(data: data)
            })
            .store(in: &cancellable)
        
        teamListVM?.fetchmyTeamAsyncCall()
    }
    
    func fetchBoughtPlayerDetails() {
        buyPlayerVM = BuyPlayerViewModel()
        buyPlayerVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        buyPlayerVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        buyPlayerVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] isBuyed in
                if isBuyed?.message == "success" {
                    self?.loadFunctionalityOn_buy_success()
                }
            })
            .store(in: &cancellable)
    }
    
    ///make netwrok call to buy player
    func makeNetworkCall() {
        let stringValue = value ?? ""
        if let value = valueFromAbbreviation(stringValue) {
            buyPlayerVM?.buyPlayerAsyncData(id: Int(playerID ?? "0")!,
                                            name: name ?? "",
                                            position: position ?? "",
                                            marketValue: String(value),
                                            img_url: image ?? "")
        } else{
            print("Invalid input")
        }
    }
    
    ///make network call to update user budget
    func makeNetworkCall_toUpdateBudget(_ userFinalBudget: Double) {
        updateInfoVM.updateBudgetAsyncCall(budget: Int(userFinalBudget))
    }
}

/// __Supportive functions
extension BuyPlayerViewController {
    
    func updateUI() {
        self.view.addSubview(Loader.activityIndicator)
        
        playerImage.heroID = image
        playerNameLabel.heroID = name
        
        playerImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        playerImage.sd_setImage(with: URL(string: image ?? ""))
        playerNameLabel.text = name
        positionNameLabel.text = position
        marketValueLabel.text = value
    }
    
    private func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func checkLocalisation() {
        let marketValue = UserDefaults.standard.budget
        currentBudgetLabel.text = "\(StringConstants.currentBudget.localized) \(formatNumber(Double(marketValue!)))"
        buyButton.setTitle(StringConstants.buy.localized, for: .normal)
        cancelButton.setTitle(StringConstants.cancel.localized, for: .normal)
    }
    
    private func storePlayerID(data: MyTeam) {
        for i in 0..<data.count {
            myTeam.append(data[i].playerID)
        }
    }
    
    func checkUserBudget() {
        guard let playerValue = valueFromAbbreviation(value ?? "") else {
            return
        }
        let userBudget = UserDefaults.standard.budget!
        Double(userBudget) > playerValue ? makeNetworkCall() : self.view.makeToast(ErrorMessage.insufficientBudget.localized, duration: 2.0, position: .center)
    }
    
    ///calculate user budget after buying player
    func calculateBudget() -> Double {
        let userBudget = UserDefaults.standard.budget!
        let playerValue = valueFromAbbreviation(value ?? "")
        let userFinalBudget = budgetClass.performOperation(Double(userBudget), playerValue ?? 0, operation: -)
        return userFinalBudget
    }
    
    func loadFunctionalityOn_buy_success() {
        let newUserBudget = calculateBudget()
        makeNetworkCall_toUpdateBudget(newUserBudget)
        UserDefaults.standard.budget = Int(newUserBudget)
        self.view.makeToast(ErrorMessage.playerBuyed.localized, duration: 2.0, position: .center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            /// Notify the delegate
            self.delegate?.controllerDismissed()
            self.dismiss(animated: true)
        }
    }
}
