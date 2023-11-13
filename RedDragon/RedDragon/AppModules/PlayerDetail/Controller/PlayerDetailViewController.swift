//
//  PlayerDetailViewController.swift
//  RedDragon
//
//  Created by Ali on 11/1/23.
//

import UIKit
import SDWebImage
import Combine


class PlayerDetailViewController: UIViewController {
    
    var playerDetailsArr = ["Profile", "Matches", "Stats", "Media"]

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var playerDetailCollectionView: UICollectionView!
    @IBOutlet weak var playerProfileView: PlayerProfileTopView!
    
    private var tabViewControllers: [UIViewController] = []
    private var playerDetailViewModel: PlayerDetailViewModel?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    func loadFunctionality() {
        nibInitialization()
        playerTabsData()
      //  configureUI()
        fetchPlayerDetailsViewModel()
        makeNetworkCall()
    }
    
    func nibInitialization() {
        playerDetailCollectionView.register(CellIdentifier.matchTabsCollectionViewCell)
       
    }
    
    func playerTabsData() {
        playerDetailsArr = [StringConstants.profile.localized,
                          StringConstants.matches.localized,
                          StringConstants.stats.localized,
                          StringConstants.media.localized]
        
        tabViewControllers = [PlayerDetailProfileViewController(),
                              PlayerDetailMatchesViewController(),
                              PlayerDetailStatsViewController(),
                              PlayerDetailMediaViewController()]
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        playerDetailViewModel?.fetchPlayerDetailAsyncCall(lang: "en", slug: "nick-pope")
    }
    
}

extension PlayerDetailViewController {
    ///fetch viewModel for Match details
    func fetchPlayerDetailsViewModel() {
        playerDetailViewModel = PlayerDetailViewModel()
        playerDetailViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        playerDetailViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        playerDetailViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PlayerDetailModel) {
        let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            playerProfileView.nameLbl.text = data?.playerName
            playerProfileView.profileImg.sd_imageIndicator = SDWebImageActivityIndicator.white
            playerProfileView.profileImg.sd_setImage(with: URL(string: data?.playerPhoto ?? ""))
           // playerProfileView.positionLbl.text = "\(data?.indicators?["Main position"].value)"
           // playerProfileView.valueLbl.text = "\(data?.indicators?["Rating"].value)"
            
            profileFirstIndex_collectionView()
            self.view.layoutIfNeeded()
        }
    }
}

extension PlayerDetailViewController {
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    func configureUI() {
        addActivityIndicator()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureLanguage() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
       // fetchCurrentLanguageCode = lang
    }
    
    func profileFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        playerDetailCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(playerDetailCollectionView, didSelectItemAt: indexPath)
    }
    
    func embedProfileVC() {
            ViewEmbedder.embed(withIdentifier: "PlayerDetailProfileViewController", storyboard: UIStoryboard(name: StoryboardName.playerDetail, bundle: nil), parent: self, container: viewContainer) { [self] vc in
                let vc = vc as! PlayerDetailProfileViewController
                vc.configureView()
                //viewContainerHeight.constant = vc.view.frame.size.height
            }
        }
    
}


extension PlayerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.matchTabsCollectionViewCell, for: indexPath) as! MatchTabsCollectionViewCell
        cell.tabNameLabel.text = playerDetailsArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 30)
        }
    
}
