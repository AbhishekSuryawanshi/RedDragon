//
//  MatchDetailsVC.swift
//  RedDragon
//
//  Created by QASR02 on 02/11/2023.
//

import UIKit
import Combine
import SDWebImage

class MatchDetailsVC: UIViewController {
    
    @IBOutlet weak var matchTabsCollectionView: UICollectionView!
    
    private var cancellable = Set<AnyCancellable>()
    private var matchDetailViewModel: MatchDetailsViewModel?
    private var fetchCurrentLanguageCode = String()
    private var matchTabsArray = [String]()
    var matchSlug: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNetworkCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    func loadFunctionality() {
        nibInitialization()
        matchTabsData()
        configureUI()
        fetchMatchDetailsViewModel()
    }
    
    func matchTabsData() {
        matchTabsArray = [StringConstants.highlight.localized,
                          StringConstants.stat.localized,
                          StringConstants.lineup.localized,
                          StringConstants.bets.localized,
                          StringConstants.odds.localized,
                          StringConstants.analysis.localized,
                          StringConstants.expert.localized ]
    }
    
    func nibInitialization() {
        matchTabsCollectionView.register(CellIdentifier.matchTabsCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        guard Reachability.isConnectedToNetwork() else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
            return
        }
        matchDetailViewModel?.fetchMatchDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", 
                                                        slug: "2023-02-21-liverpool-real-madrid",
                                                        sports: "football") //2023-02-21-liverpool-real-madrid //matchSlug ?? ""
    }
}

extension MatchDetailsVC {
    ///fetch viewModel for Match details
    func fetchMatchDetailsViewModel() {
        matchDetailViewModel = MatchDetailsViewModel()
        matchDetailViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        matchDetailViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        matchDetailViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                print(data!)
                self?.matchTabsCollectionView.reloadData()
            })
            .store(in: &cancellable)
    }
}

extension MatchDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchTabsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.matchTabsCollectionViewCell, for: indexPath) as! MatchTabsCollectionViewCell
        cell.tabNameLabel.text = matchTabsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(matchTabsArray[indexPath.item])
    }
}

/// __Supportive function calls

extension MatchDetailsVC {
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    func configureUI() {
        addActivityIndicator()
        highlightFirstIndex_collectionView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        matchTabsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(matchTabsCollectionView, didSelectItemAt: indexPath)
    }
}
