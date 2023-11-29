//
//  GossipVC.swift
//  RedDragon
//
//  Created by Qasr01 on 27/11/2023.
//

import UIKit
import Combine
import MarqueeLabel

class GossipVC: UIViewController {
    
    @IBOutlet weak var breakngNewsImage: UIImageView!
    @IBOutlet weak var topMarqueeLabel: MarqueeLabel!
    @IBOutlet weak var publisherCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    
    var cancellable = Set<AnyCancellable>()
    var isPagination = false
    var publishersArray: [String] = []
    var gossipsArray: [Gossip] = []
    var leagueArray: [SocialLeague] = []
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func initialSettings() {
        nibInitialization()
        
        /// breakng news view
        topMarqueeLabel.text = "......comng soon....."
        topMarqueeLabel.type = .continuous
        topMarqueeLabel.speed = .duration(5)
        topMarqueeLabel.animationCurve = .linear
        topMarqueeLabel.fadeLength = 10.0
        
        breakngNewsImage.zoomAnimation()
        
        fetchSocialViewModel()
        fetchGossipViewModel()
        
        SocialPublicLeagueVM.shared.fetchLeagueListAsyncCall()
        getNewsList(pageNum: 1, source: "")
    }
    
    func nibInitialization() {
        publisherCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        
    }
}

// MARK: - API Services
extension GossipVC {
    func getNewsList(pageNum: Int, source: String) {
        let param: [String: Any] = [
            "page": pageNum,
            "source": source,
            "category": "football"
        ]
        GossipListVM.shared.fetchNewsListAsyncCall(params: param)
    }
    
    func fetchSocialViewModel() {
        ///fetch public league list / euro 5 league
        SocialPublicLeagueVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialPublicLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.leagueArray = response ?? []
             })
            .store(in: &cancellable)
    }
    
    func fetchGossipViewModel() {
        ///fetch news list
        GossipListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        GossipListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onGossipsResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onGossipsResponseData(_ response: GossipListResponse?) {
        publishersArray = response?.source ?? []
        
        if self.pageNum == 1 {
            gossipsArray.removeAll()
            GossipListVM.shared.gossipsArray.removeAll()
        }
        
        if (response?.data?.data ?? []).count > 0 {
            self.gossipsArray.append(contentsOf: response?.data?.data ?? [])
            GossipListVM.shared.gossipsArray = self.gossipsArray
            self.isPagination = false
        }
        
        publisherCollectionView.reloadData()
        leagueCollectionView.reloadData()
    }
}


// MARK: - CollectionView Delegates
extension GossipVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == publisherCollectionView {
            if publishersArray.count == 0 {
                collectionView.setEmptyMessage(ErrorMessage.dataNotFound)
            } else {
                collectionView.restore()
            }
            return publishersArray.count
        } else if collectionView == leagueCollectionView {
            if leagueArray.count == 0 {
                collectionView.setEmptyMessage(ErrorMessage.leaguesEmptyAlert)
            } else {
                collectionView.restore()
            }
            return leagueArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == publisherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let publisher = publishersArray[indexPath.row].getNewsSource()
            cell.configure(title: publisher.0, iconImage: publisher.1)
            return cell
        } else if collectionView == leagueCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = leagueArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, imageWidth: (0.7 * 60), placeHolderImage: .placeholderLeague)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension GossipVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension GossipVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == publisherCollectionView || collectionView == leagueCollectionView {
            return CGSize(width: 75, height: 112)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}
