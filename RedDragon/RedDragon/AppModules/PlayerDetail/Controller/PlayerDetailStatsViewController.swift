//
//  PlayerDetailStatsViewController.swift
//  RedDragon
//
//  Created by Ali on 11/8/23.
//

import UIKit

class PlayerDetailStatsViewController: UIViewController {

    @IBOutlet weak var cardsLbl: UILabel!
    @IBOutlet weak var cardsCollectionView: UICollectionView!{
        didSet{
            self.cardsCollectionView.register("PlayerStatsCollectionViewCell")
        }
    }
    @IBOutlet weak var cardsView: UIView!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var otherCollectionView: UICollectionView!{
        didSet{
            self.otherCollectionView.register("PlayerStatsCollectionViewCell")
        }
    }
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var defendingLbl: UILabel!
    @IBOutlet weak var defendingCollectionView: UICollectionView!{
        didSet{
            self.defendingCollectionView.register("PlayerStatsCollectionViewCell")
        }
    }
    @IBOutlet weak var defendingView: UIView!
    @IBOutlet weak var passesLbl: UILabel!
    @IBOutlet weak var passesCollectionView: UICollectionView!{
        didSet{
            self.passesCollectionView.register("PlayerStatsCollectionViewCell")
        }
    }
    @IBOutlet weak var passesView: UIView!
    @IBOutlet weak var attackingLbl: UILabel!
    @IBOutlet weak var attackingCollectionView: UICollectionView!{
        didSet{
            self.attackingCollectionView.register("PlayerStatsCollectionViewCell")
        }
    }
    @IBOutlet weak var attackingView: UIView!
    @IBOutlet weak var matchesLbl: UILabel!
    @IBOutlet weak var matchesCollectionView: UICollectionView!{
        didSet{
            self.matchesCollectionView.register("PlayerStatsCollectionViewCell")
        }
    }
    @IBOutlet weak var matchesView: UIView!
    
    var playerDetailViewModel: PlayerDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        self.cardsCollectionView.reloadData()
        
    }
    
    
}

extension PlayerDetailStatsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerStatsCollectionViewCell", for: indexPath)
        return cell
    }
    
    
}
