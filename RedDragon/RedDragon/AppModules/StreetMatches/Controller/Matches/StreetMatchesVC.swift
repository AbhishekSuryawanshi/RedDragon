//
//  StreetMatchesVC.swift
//  RedDragon
//
//  Created by Remya on 11/28/23.
//

import UIKit
import Combine

enum MatchTypes:String{
    case today = "0";
    case scheduled = ">,0";
    case past = "<,0"
    
}

class StreetMatchesVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    var types = ["All".localized,"Today".localized,"Scheduled".localized,"Past".localized]
    private var matchListVM : StreetMatchesViewModel?
    private var cancellable = Set<AnyCancellable>()
    var matchList:[StreetMatch]?
    var originalMatchesList:[StreetMatch]?

    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        fetchStadiumListViewModel()
        makeNetworkCall(offset: "")
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.streetMatchTableViewCell)
        collectionView.register(CellIdentifier.selectionCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchStadiumListViewModel() {
        matchListVM = StreetMatchesViewModel()
        matchListVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        matchListVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        matchListVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let matchList = response?.response?.data{
                    self?.execute_onResponseData(matchList: matchList)
                }
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(matchList:[StreetMatch]) {
        self.matchList = matchList
        self.originalMatchesList = matchList
        self.tableView.reloadData()
    }
    
    func makeNetworkCall(offset:String){
        matchListVM?.fetchMatchesListAsyncCall(offset: offset)
    }
}


extension StreetMatchesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.selectionCollectionViewCell, for: indexPath) as! SelectionCollectionViewCell
            cell.lblTitle.text = types[indexPath.row]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var offset = ""
            switch indexPath.row{
               
            case 0:
                offset = ""
            case 1:
                offset = MatchTypes.today.rawValue
                
            case 2:
                offset = MatchTypes.scheduled.rawValue
                
            case 3:
                offset = MatchTypes.past.rawValue
            default:
                break
            }
            makeNetworkCall(offset: offset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let w = UIScreen.main.bounds.width - 35
            return CGSize(width: w/CGFloat(types.count), height: 40)
    }
}


extension StreetMatchesVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
        cell.configureCell(obj: matchList?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(StreetMatchesDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.matchID = self.matchList?[indexPath.row].id
        }
    }
}

extension StreetMatchesVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStreetMatches(searchText: searchText)
    }
    func searchStreetMatches(searchText:String){
        if searchText == ""{
            matchList = originalMatchesList
            tableView.reloadData()
            searchBar.endEditing(true)
        }
        else{
            matchList?.removeAll()
            matchList = originalMatchesList?.filter{($0.homeTeam?.name?.lowercased().contains(searchText.lowercased()) ?? false ) || ($0.awayTeam?.name?.lowercased().contains(searchText.lowercased()) ?? false )}
            tableView.reloadData()
        }
    }
}
