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
    @IBOutlet weak var firstPointsLabel: UILabel!
    @IBOutlet weak var firstPriceLabel: UILabel!
    @IBOutlet weak var secondPonitsLabel: UILabel!
    @IBOutlet weak var secondPriceLabel: UILabel!
    @IBOutlet weak var thirdPointsLabel: UILabel!
    @IBOutlet weak var thirdPriceLabel: UILabel!
    @IBOutlet weak var fourthPointsLabel: UILabel!
    @IBOutlet weak var fourthPriceLabel: UILabel!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    private var cancellable = Set<AnyCancellable>()
    private var bannerVM: BannerViewModel?
    private var banners_count = 0
    private var timer = Timer()
    
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
    }
    
    func refreshView() {
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            WalletVM.shared.subscriptionListAsyncCall()
        }
        heatPointTitleLabel.text = "Your HeatPoints Balance".localized + "🔥"
        recentTrasactionLabel.text = "Recent Transactions".localized
        transactionSeeAllButton.setTitle("View All".localized, for: .normal)
        packageLabel.text = "Packages".localized
    }
    
    func nibInitialization() {
        bannerCollectionView.register(CellIdentifier.bannerCell)
    }
    
    private func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
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
    
    func execute_onSubscriptionsResponseData(_ response: SubscriptionResponse?) {
        fetchBannerViewModel()
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
        return bannerVM?.responseData?.data.top.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let banner = bannerVM?.responseData?.data.top else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.bannerCell, for: indexPath) as! BannerCollectionViewCell
        cell.bannerImage.setImage(imageStr:URLConstants.bannerBaseURL + banner[indexPath.item].coverPath, placeholder: .empty)
        return cell
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
        }
    }
}

extension WalletVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: 220)
    }
}
