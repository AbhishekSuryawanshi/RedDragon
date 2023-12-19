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
        fetchBannerViewModel()
    }
    
    func refreshView() {
        
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
    private func fetchBannerViewModel() {
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
}

// MARK: - TableView Delegates
extension WalletVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subscriptionTableHeightConstraint.constant = (5 * 55) + 60
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.subscriptionTableViewCell, for: indexPath) as! SubscriptionTableViewCell
        
        return cell
    }
}

extension WalletVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
