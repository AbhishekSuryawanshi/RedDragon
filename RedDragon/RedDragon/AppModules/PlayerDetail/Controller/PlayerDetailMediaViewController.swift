//
//  PlayerDetailMediaViewController.swift
//  RedDragon
//
//  Created by Ali on 11/8/23.
//

import UIKit

class PlayerDetailMediaViewController: UIViewController {

    @IBOutlet weak var mediaTopView: PlayerDetailsTopView!
    @IBOutlet weak var mediaCollectionView: UICollectionView!{
        didSet{
            self.mediaCollectionView.register("PlayerDetailsMediaCollectionViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension PlayerDetailMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerDetailsMediaCollectionViewCell", for: indexPath)
        return cell
    }
    
    
}
