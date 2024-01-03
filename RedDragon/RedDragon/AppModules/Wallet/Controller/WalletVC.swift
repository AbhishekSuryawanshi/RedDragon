//
//  WalletVC.swift
//  RedDragon
//
//  Created by Qasr01 on 18/12/2023.
//

import UIKit
import Combine

class WalletVC: UIViewController {
    
    @IBOutlet weak var heatPointTitleLabel: UILabel!
    @IBOutlet weak var heatPointLabel: UILabel!
    @IBOutlet weak var recentTrasactionLabel: UILabel!
    @IBOutlet weak var transactionSeeAllButton: UIButton!
    @IBOutlet weak var subscriptionTableview: UITableView!
    @IBOutlet weak var subscriptionTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var saveUptoLabel: UILabel!
    @IBOutlet weak var betPointsCollectionView: UICollectionView!
    
    @IBOutlet weak var convertBetLabel: UILabel!
    @IBOutlet weak var heatPointsCollectionView: UICollectionView!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    private var cancellable = Set<AnyCancellable>()
    private var bannerVM: BannerViewModel?
    private var banners_count = 0
    private var timer = Timer()
    private var pointType: PointsType = .bet
    private var selectedIndex = 0 //for heat and bet points packages list index
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func initialSettings() {
        nibInitialization()
        fetchWalletViewModel()
        fetchBannerViewModel()
        fetchPointsViewModel()
    }
    
    func refreshView() {
       // Show heat points and transactions for loggined user
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            showTransactions()
        }
        heatPointTitleLabel.text = "Your HeatPoints Balance".localized + "🔥"
        recentTrasactionLabel.text = "Recent Transactions".localized
        transactionSeeAllButton.setTitle("View All".localized, for: .normal)
        packageLabel.text = "Packages".localized
        convertBetLabel.text = "Convert Bet Diamonds to Heat Points".localized
    }
    
    func nibInitialization() {
        bannerCollectionView.register(CellIdentifier.bannerCell)
        betPointsCollectionView.register(CellIdentifier.pointsCollectionViewCell)
        heatPointsCollectionView.register(CellIdentifier.pointsCollectionViewCell)
    }
    
    private func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func showTransactions() {
        heatPointLabel.text = String(UserDefaults.standard.user?.wallet ?? 0)
        WalletVM.shared.subscriptionListAsyncCall()
    }
    
    @objc func pageControllerForBanners() {
        guard let dataCount = bannerVM?.responseData?.data.top.count else { return }
        
        let count = min(dataCount, 3)
        if banners_count < count {
            let index = IndexPath.init(row: banners_count, section: 0)
            bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        } else {
            banners_count = 0
            let index = IndexPath.init(row: banners_count, section: 0)
            bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
        banners_count = (banners_count + 1) % dataCount
    }
    
    func purchasePoints(type: PointsType, index: Int) {
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
        
            presentOverViewController(GetPointsVC.self, storyboardName: StoryboardName.wallet) { vc in
                vc.selectedIndex = index
                vc.pointType = type
                vc.delegate = self
            }
            
        } else {
            self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                /// Show login page to login/register new user
                /// hide tabbar before presenting a viewcontroller
                /// show tabbar while dismissing a presented viewcontroller in delegate
                self.tabBarController?.tabBar.isHidden = true
                self.presentOverViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.delegate = self
                }
            }
        }
    }
}

// MARK: - API Services
extension WalletVC {
    func fetchWalletViewModel() {
        ///fetch subscription list
        WalletVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        WalletVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        WalletVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onSubscriptionsResponseData(response)
            })
            .store(in: &cancellable)
        
        /// Purchase Package
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
                
                //Update bet points / bet transaction
                self?.updateBetPoints()
                
                if let dataResponse = response?.response {
                    self?.showTransactions()
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
    }
    
    func fetchBannerViewModel() {
        bannerVM = BannerViewModel()
        bannerVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.bannerNotFound.localized, duration: 2.0, position: .center)
        }
        bannerVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        bannerVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.bannerCollectionView.reloadData()
                if self?.banners_count == 0 {
                    self?.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self!, selector: #selector(self?.pageControllerForBanners), userInfo: nil, repeats: true)
                }
            })
            .store(in: &cancellable)
        /// API call for banners
        bannerVM?.fetchBannerDataAsyncCall()
    }
    
    ///fetch view model for points
    func fetchPointsViewModel() {
        PointsViewModel.shared.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.bannerNotFound.localized, duration: 2.0, position: .center)
        }
        PointsViewModel.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        PointsViewModel.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] points in
                
            })
            .store(in: &cancellable)
    }
    
    func updateBetPoints() {
        let betDiffValue = (pointType == .bet ? 1 : -1) * WalletVM.shared.betsArray[selectedIndex]
        
        let param: [String: Any] = [
            "amount": betDiffValue,
            "message": "Package purchased"
        ]
        PointsViewModel.shared.fetchPointsAsyncCall(params: param)
    }
    
    func execute_onSubscriptionsResponseData(_ response: SubscriptionResponse?) {
       
        if let dataResponse = response?.response {
            WalletVM.shared.subscriptionArray = dataResponse.data ?? []
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
        subscriptionTableview.reloadData()
    }
}

// MARK: - TableView Delegates
extension WalletVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subscriptionTableHeightConstraint.constant = CGFloat(WalletVM.shared.subscriptionArray.count * 60) + (WalletVM.shared.subscriptionArray.count == 0 ? 0 : 60)
        return WalletVM.shared.subscriptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.subscriptionTableViewCell, for: indexPath) as! SubscriptionTableViewCell
        cell.setCellValues(model: WalletVM.shared.subscriptionArray[indexPath.row])
        return cell
    }
}

extension WalletVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - CollectionView Delegates
extension WalletVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return bannerVM?.responseData?.data.top.count ?? 0
        } else {
          return  WalletVM.shared.betsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            guard let banner = bannerVM?.responseData?.data.top else {
                return UICollectionViewCell()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.bannerCell, for: indexPath) as! BannerCollectionViewCell
            cell.bannerImage.setImage(imageStr:URLConstants.bannerBaseURL + banner[indexPath.item].coverPath, placeholder: .empty)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.pointsCollectionViewCell, for: indexPath) as! PointsCollectionViewCell
            if collectionView == betPointsCollectionView {
                cell.titleLabel.text = "\(WalletVM.shared.betsArray[indexPath.row]) BDs"
                cell.subTitleLabel.text = "for".localized + " \(WalletVM.shared.heatsArray[indexPath.row])🔥"
            } else {
                cell.titleLabel.text = "\(WalletVM.shared.heatsArray[indexPath.row]) HPs"
                cell.subTitleLabel.text = "for".localized + " \(WalletVM.shared.betsArray[indexPath.row])🔥"
            }
            return cell
        }
    }
}

extension WalletVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            let bannerMesssage = bannerVM?.responseData?.data.top[indexPath.item].message ?? ""
            if bannerMesssage.contains("http") || bannerMesssage.contains("www"){
                guard let url = URL(string: bannerMesssage) else { return }
                UIApplication.shared.open(url)
            }
        } else {
            purchasePoints(type: collectionView == self.betPointsCollectionView ? .bet : .heat, index: indexPath.row)
        }
    }
}

extension WalletVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: screenWidth, height: 220)
        } else {
            return CGSize(width: 90, height: 75)
        }
    }
}

// MARK: - Custom Delegates
extension WalletVC: GetPointsVCDelegate {
    func PointPurchased(index: Int, type: PointsType) {
        selectedIndex = index
        pointType = type
        
        //Update heat point and after api response update bet points
        
        let param: [String: Any] = [
            "coin_count": WalletVM.shared.heatsArray[selectedIndex],
            "type": pointType == .bet ? "d" : "c",
            "event": "Package purchased"
        ]
        AddWalletVM.shared.addTransaction(parameters: param)
    
    }
}

/// LoginVCDelegate to show hided tabbar
extension WalletVC: LoginVCDelegate {
    func viewControllerDismissed() {
        showTransactions()
        self.tabBarController?.tabBar.isHidden = false
    }
}
