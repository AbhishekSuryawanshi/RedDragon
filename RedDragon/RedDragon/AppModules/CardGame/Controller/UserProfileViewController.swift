//
//  UserProfileViewController.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import UIKit
import Toast
import Combine
import SDWebImage

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreLabelView: UIView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winCountLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    @IBOutlet weak var lossCountLabel: UILabel!
    @IBOutlet weak var totalPlayedLabel: UILabel!
    @IBOutlet weak var totalPlayedCountLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previousMatchesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteToPlayButton: UIButton!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var teamCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var cancellable = Set<AnyCancellable>()
    var leaderboardDetailsVM: LeaderboardDetailViewModel?
    var teamListVM: MyTeamViewModel?
    var yourMatchesVM: MatchesViewModel?
    
    var userID: Int = 0
    var againstComputer : Bool?
    var opponentPlayrsID : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchViewModel()
        fetchMatchViewModel()
        makeNetworkCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteToPlayButton(_ sender: Any) {
        let guest = UserDefaults.standard.bool(forKey: UserDefaultString.guestUser)
        if guest {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.loginRequires.localized, image: ImageConstants.alertImage)
        }
        else {
            if leaderboardDetailsVM?.responseData?.players.count == 0 {
                self.view.makeToast(ErrorMessage.noPlayers.localized, duration: 2.0, position: .center)
            } else {
                let players = leaderboardDetailsVM?.responseData?.players
                if players?.count ?? 0 >= 11 {
                    againstComputer = false
                    UserDefaults.standard.set(false, forKey: "gameEnd")
                    fetchMyTeamViewModel()
                    fetchOpponentPlayersID(leaderboardDetailsVM?.responseData)
                }
            }
        }
    }
    
    ///fetch opponent players ID
    func fetchOpponentPlayersID(_ team: LeaderboardDetail?) {
        let data = team?.players
        for i in 0..<(data?.count ?? 0) {
            let playerIDs = data?[i].playerID ?? 0
            opponentPlayrsID.append(playerIDs)
        }
    }
    
}

/// __fetch view model and make a network call
extension UserProfileViewController {
    
    func fetchViewModel() {
        leaderboardDetailsVM = LeaderboardDetailViewModel()
        leaderboardDetailsVM?.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        leaderboardDetailsVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        leaderboardDetailsVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] detail in
                self?.loadData()
                self?.collectionView.reloadData()
                if detail?.players.count != 0 {
                    self?.teamCollectionViewHeight.constant = 120
                }
            })
            .store(in: &cancellable)
    }
    
    func fetchMyTeamViewModel() {
        teamListVM = MyTeamViewModel()
        teamListVM?.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        teamListVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        teamListVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] team in
                self?.fetchPlayersID(team)
            })
            .store(in: &cancellable)
        
        teamListVM?.fetchmyTeamAsyncCall()
    }
    
    ///fetch my team players ID
    func fetchPlayersID(_ team: MyTeam?) {
        if let team = team {
            let playerIDs = team.map { $0.playerID }
            if playerIDs.count < 11 {
                customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.addPlayerToPlay.localized, image: ImageConstants.alertImage)
            } else {
                /// __Present game screen
                presentToViewController(GameViewController.self, storyboardName: StoryboardName.cardGameMatch) { [self] vc in
                    vc.playersIDs = playerIDs
                    vc.opponent_playersIDs = opponentPlayrsID
                    vc.againstComputer = againstComputer
                    vc.opponentUserName = leaderboardDetailsVM?.responseData?.name
                    vc.opponentUserID = leaderboardDetailsVM?.responseData?.id
                    vc.opponentUserProfileImage = leaderboardDetailsVM?.responseData?.imgURL
                }
            }
        }
    }
    
    func fetchMatchViewModel() {
        yourMatchesVM = MatchesViewModel()
        yourMatchesVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        yourMatchesVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        yourMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] leaderboard in
                self?.tableView.reloadData()
            })
            .store(in: &cancellable)
    }
}

/// __Supportive functions
extension UserProfileViewController {
    
    private func loadFunctionality() {
        initialize()
        checkLocalisation()
        nibInitialization()
        labelRoundedCorner()
    }
    
    private func nibInitialization() {
        collectionView.register(CellIdentifier.myTeamCell)
        tableView.register(CellIdentifier.yourMatches)
    }
    
    private func initialize() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.addSubview(Loader.activityIndicator)
        teamCollectionViewHeight.constant = 0
        view.layoutIfNeeded()
    }
    
    private func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    private func labelRoundedCorner() {
        scoreLabelView.borderColor = #colorLiteral(red: 0.7895337343, green: 0.174926281, blue: 0.06877139956, alpha: 1)
        scoreLabelView.borderWidth = 1.0
        scoreLabelView.layer.cornerRadius = 13
        scoreLabelView.clipsToBounds = true
    }
    
    private func makeNetworkCall() {
        leaderboardDetailsVM?.leaderboardDetailAsyncCall(userID: userID)
        yourMatchesVM?.yourMatchesAsyncCall()
    }
    
    private func loadData() {
        setUserDetail()
        setImage()
        setMatchStatus()
    }
    
    private func setUserDetail() {
        nameLabel.text = leaderboardDetailsVM?.responseData?.name
        scoreLabel.text = "\(StringConstants.score.localized) \(leaderboardDetailsVM?.responseData?.score ?? 0)"
        budgetLabel.text = formatNumber(Double(leaderboardDetailsVM?.responseData?.budget ?? 0))
    }
    
    private func setImage() {
        userImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        userImageView.sd_setImage(with: URL(string: leaderboardDetailsVM?.responseData?.imgURL ?? ""), placeholderImage: #imageLiteral(resourceName: "cardGame_defaultUser"))
    }
    
    private func setMatchStatus() {
        winCountLabel.text = "\(leaderboardDetailsVM?.responseData?.matchStats.wins ?? 0)"
        lossCountLabel.text = "\(leaderboardDetailsVM?.responseData?.matchStats.loses ?? 0)"
        totalPlayedCountLabel.text = "\(leaderboardDetailsVM?.responseData?.matchStats.total ?? 0)"
    }
    
    private func checkLocalisation() {
        winLabel.text = StringConstants.win.localized
        lossLabel.text = StringConstants.loss.localized
        totalPlayedLabel.text = StringConstants.totalGames.localized
        teamLabel.text = StringConstants.team.localized
        inviteToPlayButton.setTitle(StringConstants.inviteToPlay.localized, for: .normal)
    }
}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if leaderboardDetailsVM?.responseData?.players.count == 0 {
            self.view.makeToast(ErrorMessage.playerListUnavailable.localized, duration: 2.0, position: .center)
        }
        return leaderboardDetailsVM?.responseData?.players.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let players = leaderboardDetailsVM?.responseData?.players else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.myTeamCell, for: indexPath) as! MyTeamCollectionViewCell
        cell.confiure(data: players[indexPath.item])
        let marketValue = Double(players[indexPath.item].marketValue) ?? 0
        cell.priceLabel.text = formatNumber(marketValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCollectionView(collectionView, willDisplay: cell, forItemAt: indexPath, animateDuration: 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width/3 - 5, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourMatchesVM?.responseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = yourMatchesVM?.responseData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.yourMatches, for: indexPath) as! YourMatchesTableCell
        cell.configure(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeight.constant = self.tableView.contentSize.height
    }
}

