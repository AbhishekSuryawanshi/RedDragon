//
//  BetHomeVc.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit
import SideMenu
import Combine


class BetHomeVc: UIViewController {
    
    var viewModel = BetsHomeViewModel()
    var selectedType : BetsTitleCollectionView = .All
    var matchesList : [MatchesList]?
    private var fetchCurrentLanguageCode = String()
    private var cancellable = Set<AnyCancellable>()

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initial()
        configureLanguage()
        networkCall()
        fetchBetMetches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addActivityIndicator()
    }

    func initial(){
        tableView.register(CellIdentifier.betMatchTableVC)
        tableView.register(CellIdentifier.betWinTableVC)
        tableView.register(CellIdentifier.betLoseTableVC)
        collectionView.register(CellIdentifier.homeTitleCollectionVc)
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    func networkCall(){
        viewModel.fetchAllBetsAsyncCall(sport: .football, lang: fetchCurrentLanguageCode == "en" ? "en" : "zh")
    }

    // MARK: - Navigation

     @IBAction func btnMenu(_ sender: Any) {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "SideNav") as! SideMenuNavigationController
         self.present(menu, animated: true)
     }
     
}

extension BetHomeVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.homeTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
        cell.titleLable.text = viewModel.homeTitles[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = viewModel.homeTitles[indexPath.row]
        tableView.reloadData()
    }
    
}


extension BetHomeVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(selectedType){
        case .All:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
            cell.configurCell(match: matchesList![indexPath.row])
            return cell
            
        case .Win:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betWinTableVC) as! BetWinTableVC
            
            return cell
            
        case .Lose:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betLoseTableVC) as! BetLoseTableVC
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
        
            return cell
        }
        
      
    }
    
    
    
}


extension BetHomeVc {
        
        ///fetch view model for bet matches
        func fetchBetMetches() {
            viewModel.showError = { [weak self] error in
                self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
            }
            viewModel.displayLoader = { [weak self] value in
                self?.showLoader(value)
            }
            viewModel.$responseData
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(receiveValue: { [weak self] matches in
                    self?.execute_onResponseData(matches!)
                })
                .store(in: &cancellable)
        }
        
        func execute_onResponseData(_ matches: MatchListModel) {
          
            matchesList = matches.data
           tableView.reloadData()
       
        }
    
    func configureLanguage() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
}
