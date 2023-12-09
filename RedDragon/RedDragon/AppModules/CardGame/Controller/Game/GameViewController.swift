//
//  GameViewController.swift
//  RedDragon
//
//  Created by QASR02 on 08/12/2023.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var roundCountLabel: UILabel!
    @IBOutlet weak var opponentTurnView: UIView!
    @IBOutlet weak var yourTurnView: UIView!
    @IBOutlet weak var yourProfileImage: UIImageView!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var opponentProfileImage: UIImageView!
    @IBOutlet weak var opponentNamelabel: UILabel!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    @IBOutlet weak var userPlayersCollectionView: UICollectionView!
    
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var attackingCountLabel: UILabel!
    @IBOutlet weak var attackingLabel: UILabel!
    @IBOutlet weak var technicalCountLabel: UILabel!
    @IBOutlet weak var technicalLabel: UILabel!
    @IBOutlet weak var defendingCountLabel: UILabel!
    @IBOutlet weak var defendingLabel: UILabel!
    @IBOutlet weak var tacticalCountLabel: UILabel!
    @IBOutlet weak var tacticalLabel: UILabel!
    @IBOutlet weak var creativityCountLabel: UILabel!
    @IBOutlet weak var creativityLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var attackingView: UIView!
    @IBOutlet weak var technicalView: UIView!
    @IBOutlet weak var defendingView: UIView!
    @IBOutlet weak var tacticalView: UIView!
    @IBOutlet weak var creativityView: UIView!
    
    @IBOutlet weak var yourCardAndCountView: UIView!
    @IBOutlet weak var opponentCardAndCountView: UIView!
    @IBOutlet weak var youTurnLabel: UILabel!
    @IBOutlet weak var yourTurnCountdownLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var opponentCountdownLabel: UILabel!
    
    @IBOutlet weak var yourFinalCardView: UIView!
    @IBOutlet weak var yourFinalCardPlayerImage: UIImageView!
    @IBOutlet weak var yourFinalCardPlayerNameLabel: UILabel!
    @IBOutlet weak var yourFinalCardAbilityScoreLabel: UILabel!
    @IBOutlet weak var youFinalCardAbilityNameLabel: UILabel!
    
    @IBOutlet weak var opponentFinalCardView: UIView!
    @IBOutlet weak var opponentFinalCardPlayerImage: UIImageView!
    @IBOutlet weak var opponentFinalCardPlayerNameLabel: UILabel!
    @IBOutlet weak var opponentFinalCardAbilityScoreLabel: UILabel!
    @IBOutlet weak var opponentFinalCardAbilityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
