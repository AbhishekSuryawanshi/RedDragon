//
//  BetHomeVc.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit
import SideMenu

class BetHomeVc: UIViewController {
    
    var viewModel = BetsHomeViewModel()
    var selectedType : BetsTitleCollectionView = .All
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(CellIdentifier.betMatchTableVC)
        tableView.register(CellIdentifier.betWinTableVC)
        tableView.register(CellIdentifier.betLoseTableVC)
        collectionView.register(CellIdentifier.homeTitleCollectionVc)
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(selectedType){
        case .All:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
        
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
