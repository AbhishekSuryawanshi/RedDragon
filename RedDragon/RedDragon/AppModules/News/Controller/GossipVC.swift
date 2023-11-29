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
    var refreshLeagueList = true
    var isPagination = false
    var publishersArray: [String] = []
    var gossipsArray: [Gossip] = []
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func initialSettings() {
        
        /// breakng news view
        topMarqueeLabel.text = "UIView.AnimationOptions.curveEaseInOut, .repeat, .autoreverse]"
        topMarqueeLabel.type = .continuous
        topMarqueeLabel.speed = .duration(5)
        topMarqueeLabel.animationCurve = .linear
        topMarqueeLabel.fadeLength = 10.0
        
        breakngNewsImage.zoomAnimation()
        
        fetchSocialViewModel()
        fetchGossipViewModel()
        
        ///get league list
        if refreshLeagueList {
            refreshLeagueList = false
            SocialPublicLeagueVM.shared.fetchLeagueListAsyncCall()
        }
        getNewsList(pageNum: 1, source: "")
    }
    
    func getNewsList(pageNum: Int, source: String) {
        let param: [String: Any] = [
            "page": pageNum,
            "source": source,
            "category": "football"
        ]
        GossipListVM.shared.fetchNewsListAsyncCall(params: param)
    }
}

// MARK: - API Services
extension GossipVC {
    func fetchSocialViewModel() {
        ///fetch public league list / euro 5 league
        SocialPublicLeagueVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialPublicLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                SocialPublicLeagueVM.shared.leagueArray = response ?? []
                
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
        
        if response?.status == 1 {
            if (response?.data?.data ?? []).count > 0 {
                self.gossipsArray.append(contentsOf: response?.data?.data ?? [])
                GossipListVM.shared.gossipsArray = self.gossipsArray
                self.isPagination = false
            }
        } else {
            self.view.makeToast(response?.message ?? CustomErrors.noData.description)
        }
    }
}
