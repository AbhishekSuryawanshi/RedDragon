//
//  PostMatchesVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit
import Combine

protocol PostMatchesVCDelegate: AnyObject {
    func matchSelected(match: SocialMatch, matchSelected: Bool)
}

class PostMatchesVC: UIViewController {
    
    @IBOutlet weak var leagueLabeL: UILabel!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var selectMatchLabeL: UILabel!
    
    weak var delegate: PostMatchesVCDelegate?
    var cancellable = Set<AnyCancellable>()
    var selectedLeague = SocialLeague()
    var selectedMatch = SocialMatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func initialSettings() {
        self.view.addSubview(Loader.activityIndicator)
        nibInitialization()
        fetchSocialViewModel()
        setupGestureRecognizers()
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshPage()
        
        ///Show matches of first league
        ///League list already loaded in scoial vc
        selectedLeague = SocialLeagueVM.shared.leagueArray.first ?? SocialLeague()
        leagueCollectionView.reloadData()
        SocialMatchVM.shared.fetchMatchListAsyncCall(leagueId: selectedLeague.id)
    }
    func nibInitialization() {
        listTableView.register(CellIdentifier.matchTableViewCell)
        leagueCollectionView.register(CellIdentifier.singleImageCollectionViewCell)
    }
    
    func refreshPage() {
        leagueLabeL.text = "Leagues".localized
        selectMatchLabeL.text = "Select match".localized
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    private func setupGestureRecognizers() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(leftSwipe)
    }
    
    // MARK: - Gesture Action
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        delegate?.matchSelected(match: selectedMatch, matchSelected: false)
    }
}


// MARK: - API Services
extension PostMatchesVC {
    func fetchSocialViewModel() {
        ///fetch match list
        SocialMatchVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialMatchVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialMatchVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                SocialMatchVM.shared.matchArray.removeAll()
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: SocialMatchResponse?) {
        if let dataResponse = response?.response {
            SocialMatchVM.shared.matchArray = dataResponse.data ?? []
        } else {
            if let errorResponse = response?.error {
                self.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
        }
        listTableView.reloadData()
    }
}

// MARK: - CollectionView Delegates
extension PostMatchesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if SocialLeagueVM.shared.leagueArray.count == 0 {
            collectionView.setEmptyMessage(ErrorMessage.leaguesEmptyAlert)
        } else {
            collectionView.restore()
        }
        return SocialLeagueVM.shared.leagueArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.singleImageCollectionViewCell, for: indexPath) as! SingleImageCollectionViewCell
        let model = SocialLeagueVM.shared.leagueArray[indexPath.row]
        //cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, style: .league)
        cell.imageImageView.cornerRadius = 0
        cell.imageImageView.setImage(imageStr: model.logoURL, placeholder: .placeholderLeague)
        cell.imageImageView.borderColor = model.id == selectedLeague.id ? .black : .clear
        cell.imageImageView.borderWidth = model.id == selectedLeague.id ? 3 : 0
        cell.closeBgView.isHidden = true
        return cell
    }
}

extension PostMatchesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Show matches of selected league
        ///League list already loaded in scoial vc
        SocialMatchVM.shared.matchArray = []
        listTableView.reloadData()
        selectedLeague = SocialLeagueVM.shared.leagueArray[indexPath.row]
        collectionView.reloadData()
        SocialMatchVM.shared.fetchMatchListAsyncCall(leagueId: selectedLeague.id)
    }
}

extension PostMatchesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

// MARK: - TableView Delegate
extension PostMatchesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SocialMatchVM.shared.matchArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.matchEmptyAlert)
        } else {
            tableView.restore()
        }
        return SocialMatchVM.shared.matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.matchTableViewCell, for: indexPath) as! MatchTableViewCell
        cell.setCellValues(model: SocialMatchVM.shared.matchArray[indexPath.row])
        return cell
    }
}

extension PostMatchesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMatch = SocialMatchVM.shared.matchArray[indexPath.row]
        delegate?.matchSelected(match: selectedMatch, matchSelected: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

