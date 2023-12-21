//
//  DiscoverVC.swift
//  RedDragon
//
//  Created by Qasr01 on 19/12/2023.
//

import UIKit
import Combine

class DiscoverVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var profileHeaderLabel: UILabel!
    @IBOutlet weak var otherHeaderLabel: UILabel!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var otherCollectionView: UICollectionView!
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func initialSettings() {
        nibInitialization()
        fetchLoginViewModel()
    }
    
    func refreshView() {
        self.navigationController?.navigationBar.isHidden = true
        headerLabel.text = "Our Services".localized
        profileHeaderLabel.text = "Profile & Settings".localized
        otherHeaderLabel.text = "Other".localized
    }
    
    func nibInitialization() {
        servicesCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        profileCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        otherCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    // MARK: - Button Actions
    
    @IBAction func appModulesButton(_ sender: UIButton) {
        switch sender.tag {
        case 8:
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[2]
        case 15:
            self.tabBarController?.tabBar.isHidden = true
            navigateToViewController(AllPlayersViewController.self, storyboardName: StoryboardName.cardGame, identifier: "AllPlayersViewController")
        default:
            print("default")
        }
    }
}

// MARK: - API Services
extension DiscoverVC {
    func fetchLoginViewModel() {
        
        LogoutVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        LogoutVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        LogoutVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: LoginResponse?) {
        if let dataResponse = response?.response {
            UserDefaults.standard.user = nil
            UserDefaults.standard.token = nil
            UserDefaults.standard.points = nil
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}

// MARK: - CollectionView Delegates
extension DiscoverVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == servicesCollectionView {
            return ServiceType.allCases.count
        } else {
            return SettingType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
        if collectionView == servicesCollectionView {
            cell.configure(title: ServiceType.allCases[indexPath.row].rawValue.localized, titleTop: -4, iconImage: ServiceType.allCases[indexPath.row].iconImage, bgViewWidth: 55, imageWidth: (0.55 * 55))
            cell.bgView.borderWidth = 0
            cell.titleLabel.textColor = .base
        } else {
            cell.configure(title: SettingType.allCases[indexPath.row].rawValue.localized, iconImage: SettingType.allCases[indexPath.row].iconImage, bgViewWidth: 55, imageWidth: (0.65 * 55), bgViewCornerRadius: 55/2)
            cell.bgView.borderWidth = 0
            cell.bgView.backgroundColor = collectionView == profileCollectionView ? .wheat8 : .yellow4
        }
        return cell
    }
}


extension DiscoverVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == servicesCollectionView {
            switch ServiceType.allCases[indexPath.row] {
            case .predictions:
                navigateToViewController(HomePredictionViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom))
            case .bets:
                navigateToViewController(BetHomeVc.self, storyboardName: StoryboardName.bets, animationType: .autoReverse(presenting: .zoom))
            case .social:
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[1]
            case .fantasy:
                print("")
            case .quizz:
                print("")
            case .matches:
                navigateToViewController(MatchesDashboardVC.self, storyboardName: StoryboardName.matches, animationType: .autoReverse(presenting: .zoom))
            case .updates:
                navigateToViewController(NewsModuleVC.self, storyboardName: StoryboardName.news, identifier: "NewsModuleVC")
            case .database:
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[2]
            case .analysis:
                print("")
            case .users:
                print("")
            case .street:
                navigateToViewController(StreetMatchesDashboardVC.self, storyboardName: StoryboardName.streetMatches, animationType: .autoReverse(presenting: .zoom))
             case .meet:
                navigateToViewController(MeetDashboardVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom))
            case .experts:
                navigateToViewController(HomeVC.self, storyboardName: StoryboardName.home, animationType: .autoReverse(presenting: .zoom))
            case .cards:
                navigateToViewController(AllPlayersViewController.self, storyboardName: StoryboardName.cardGame, identifier: "AllPlayersViewController")
            default: //wallet
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[3]
            }
        } else {
            if SettingType.allCases[indexPath.row] == .logout {
                self.customAlertView_2Actions(title: "Logout".localized, description: StringConstants.logoutAlert.localized) {
                    LogoutVM.shared.logoutAsyncCall()
                }
            }
        }
    }
}

extension DiscoverVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == servicesCollectionView {
            return CGSize(width: (screenWidth - 25) / 5, height: 85)
        } else {
            return CGSize(width: (screenWidth - 25) / 5, height: 100)
        }
    }
}
