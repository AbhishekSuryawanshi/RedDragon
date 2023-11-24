//
//  StreetMatchHomeVC.swift
//  RedDragon
//
//  Created by Remya on 11/24/23.
//

import UIKit
import Combine

class StreetMatchHomeVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var headers = ["Available Stadiums".localized,"Feeds".localized,"Matches".localized]
    var homeData:StreetMatchHome?
    private var streethomeVM: StreetHomeViewModel?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        fetchStreetHomeViewModel()
        makeNetworkCall()
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.stadiumTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.feedsTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.streetMatchTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchStreetHomeViewModel() {
        streethomeVM = StreetHomeViewModel()
        streethomeVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        streethomeVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        streethomeVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] homeData in
                self?.execute_onResponseData(homeData: homeData!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(homeData:StreetMatchHome) {
        self.homeData = homeData
        self.tableView.reloadData()
    }
    
    func makeNetworkCall(){
        streethomeVM?.fetchStreetHomeAsyncCall()
    }
}

extension StreetMatchHomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if  (homeData?.stadiums.count ?? 0) >= 2{
                return 2
            }
            else{
                return homeData?.stadiums.count ?? 0
            }
        }
        else if section == 1{
            if (homeData?.events.count ?? 0) >= 3{
                return 3
            }
            else{
               return homeData?.events.count ?? 0
            }
        }
        else {
            return homeData?.matches.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stadiumTableViewCell, for: indexPath) as! StadiumTableViewCell
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell, for: indexPath) as! FeedsTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}