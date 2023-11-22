//
//  UpComingMatchesViewController.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit

class UpComingMatchesViewController: UIViewController {

    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var upcomingMatchesTableView: UITableView!
    
    var dateArr = ["Today", "Tomorrow", "Day3", "Day4", "Day5"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    func loadFunctionality() {
        nibInitialization()
      //  playerTabsData()
      //  configureUI()
     //   fetchPlayerDetailsViewModel()
      //  makeNetworkCall()
    }
    
    func nibInitialization() {
        dateCollectionView.register(CellIdentifier.homeTitleCollectionVc)
        upcomingMatchesTableView.register(CellIdentifier.predictUpcomingTableViewCell)
        dateCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
       
    }
    
}

extension UpComingMatchesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
        cell.titleLable.text = dateArr[indexPath.row]
        return cell
    }
    
    
}

extension UpComingMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUpcomingTableViewCell, for: indexPath) as! PredictUpcomingTableViewCell
        
        return cell
    }
    
    
}
