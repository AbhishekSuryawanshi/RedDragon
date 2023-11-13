//
//  SocialSearchVC.swift
//  RedDragon
//
//  Created by Qasr01 on 10/11/2023.
//

import UIKit
import Combine

class SocialSearchVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var matchTitleLabel: UILabel!
    @IBOutlet weak var matchTableView: UITableView!
    @IBOutlet weak var postsContainerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var cancellable = Set<AnyCancellable>()
    var matchArray: [SocialMatch] = []
    var leagueModel = SocialLeague()
    var teamModel = SocialTeam()
    var showMatches = false
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshForLocalization()
    }
    
    func refreshForLocalization() {
        Loader.activityIndicator.startAnimating()
    }
    
    func initialSettings() {
        nibInitialization()
        self.view.addSubview(Loader.activityIndicator)
        ViewEmbedder.embed(withIdentifier: "PostListVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                           , parent: self, container: postsContainerView) { vc in
            let vc = vc as! PostListVC
            vc.delegate = self
        }
        headerLabel.text = searchText
        logoView.isHidden = showMatches
        matchView.isHidden = showMatches
        
        if showMatches {
            if teamModel.id == "" {
                logoImageView.setImage(imageStr: leagueModel.logoURL, placeholder: .placeholderTeam)
            } else {
                logoImageView.setImage(imageStr: teamModel.logoURL, placeholder: .placeholderLeague)
            }
            titleLabel.text = teamModel.id == "" ? (UserDefaults.standard.language == "en" ? leagueModel.enName : leagueModel.cnName) : (UserDefaults.standard.language == "en" ? teamModel.enName : teamModel.cnName)
            matchTitleLabel.text = "Top Matches in " + (teamModel.id == "" ? "Leage" : "Team")
            SocialMatchVM.shared.fetchMatchListAsyncCall(leagueId: leagueModel.id, teamId: teamModel.id)
        } else {
            
        }
    }
    
    func nibInitialization() {
        matchTableView.register(CellIdentifier.matchTableViewCell)
    }
}

// MARK: - API Services
extension SocialSearchVC {
    func fetchSocialViewModel() {
        ///fetch match list
        SocialMatchVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
//        SocialMatchVM.shared.displayLoader = { [weak self] value in
//            self?.showLoader(value)
//        }
        SocialMatchVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.matchArray = response?.data ?? []
                self?.matchTableView.reloadData()
            })
            .store(in: &cancellable)
    }
}

// MARK: - TableView Delegate
extension SocialSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.matchEmptyAlert)
        } else {
            tableView.restore()
        }
        return matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.matchTableViewCell, for: indexPath) as! MatchTableViewCell
        cell.setCellValues(model: matchArray[indexPath.row])
        return cell
    }
}

extension SocialSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

// MARK: - Custom Delegate
extension SocialSearchVC: PostListVCDelegate {
    func postList(height: CGFloat) {
        containerHeightConstraint.constant = height
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            Loader.activityIndicator.stopAnimating()
        }
    }
}
