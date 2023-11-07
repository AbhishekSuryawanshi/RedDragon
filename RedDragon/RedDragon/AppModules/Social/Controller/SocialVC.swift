//
//  SocialVC.swift
//  RedDragon
//
//  Created by Qasr01 on 26/10/2023.
//

import UIKit
import Combine

enum socialHeaderSegment: String, CaseIterable {
    case followed = "Followed"
    case recommend = "Recommended"
    case new = "Newest"
}

class SocialVC: UIViewController {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var selectedSegment: socialHeaderSegment = .followed
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshForLocalization()
    }
    
    func loadFunctionality() {
        //Test User
        var user = User()
        user.id = 4
        user.firstName = "Joe"
        user.lastName = "Titto"
        user.email = "joe@mailinator.com"
        user.image = "http://45.76.178.21:6040/profile-images/99087FBB-6FB9-4B2B-B7D2-3BF4DD51F73320231012100148.png"
        user.token = "70|6ts3zlgn0fjtLYbooHxQniqM6I33vSc5CGXrO5K4"
        UserDefaults.standard.user = user
        UserDefaults.standard.token = user.token
        
        ViewEmbedder.embed(withIdentifier: "PostListVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                           , parent: self, container: postContainerView) { vc in
            let vc = vc as! PostListVC
            vc.delegate = self
        }
        
        self.view.addSubview(Loader.activityIndicator)
        
        nibInitialization()
        fetchSocialViewModel()
        makeNetworkCall()
    }
    
    func refreshForLocalization() {
        Loader.activityIndicator.startAnimating()
        self.tabBarController?.tabBar.isHidden = false
        leagueLabel.text = "Leagues".localized
        teamLabel.text = "Teams".localized
        createPostButton.setTitle("Create a Post".localized, for: .normal)
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        teamsCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
    }
    
    // MARK: - Button Actions
    
    @IBAction func createPostButtonTapped(_ sender: UIButton) {
        
        guard let token = UserDefaults.standard.token else {
            self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                //ToDo
                // self.logoutAndRootToLoginVC()
            }
            return
        }
        navigateToViewController(PostCreateVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom))
    }
}

// MARK: - API Services
extension SocialVC {
    func makeNetworkCall() {
//        guard Reachability.isConnectedToNetwork() else {
//            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
//            return
//        }
        
        SocialLeagueVM.shared.fetchLeagueListAsyncCall()
        
    }
    
    func fetchSocialViewModel() {
        ///fetch league list
        SocialLeagueVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] leagueData in
                SocialLeagueVM.shared.leagueArray = leagueData ?? []
                self?.leagueCollectionView.reloadData()
                SocialTeamVM.shared.fetchTeamListAsyncCall()
            })
            .store(in: &cancellable)
        
        ///fetch team list
        SocialTeamVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialTeamVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] teamData in
                SocialTeamVM.shared.teamArray = teamData ?? []
                self?.teamsCollectionView.reloadData()
            })
            .store(in: &cancellable)
    }
}

// MARK: - CollectionView Delegates
extension SocialVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return socialHeaderSegment.allCases.count
        } else if collectionView == leagueCollectionView {
            return SocialLeagueVM.shared.leagueArray.count
        } else if collectionView == teamsCollectionView {
            return SocialTeamVM.shared.teamArray.count
        } else {
            return socialHeaderSegment.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        } else if collectionView == leagueCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = SocialLeagueVM.shared.leagueArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, style: .league)
            return cell
        } else if collectionView == teamsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = SocialTeamVM.shared.teamArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, style: .team)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerBottom_1CollectionViewCell, for: indexPath) as! HeaderBottom_1CollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        }
    }
}

extension SocialVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == leagueCollectionView || collectionView == teamsCollectionView {
        } else {
            selectedSegment = socialHeaderSegment.allCases[indexPath.row]
            collectionView.reloadData()
        }
    }
}

extension SocialVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 40, height: 50)
        } else if collectionView == leagueCollectionView {
            return CGSize(width: 75, height: 112)
        } else if collectionView == teamsCollectionView {
            return CGSize(width: 75, height: 112)
        } else {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : fontMedium(15)]).width + 70, height: 40)
        }
    }
}

// MARK: - Custom Delegate
extension SocialVC: PostListVCDelegate {
    func postList(height: CGFloat) {
        containerHeightConstraint.constant = height
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            Loader.activityIndicator.stopAnimating()
        }
    }
}
