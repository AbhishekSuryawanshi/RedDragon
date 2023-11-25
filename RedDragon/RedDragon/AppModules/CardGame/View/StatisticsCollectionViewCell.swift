//
//  StatisticsCollectionViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 25/11/2023.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var totalPlayerLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var penaltyGoalsLabel: UILabel!
    @IBOutlet weak var minuitesPerGameLabel: UILabel!
    @IBOutlet weak var accuratePassesLabel: UILabel!
    @IBOutlet weak var freeKickLabel: UILabel!
    @IBOutlet weak var yelloCarLabel: UILabel!
    @IBOutlet weak var redCardLabel: UILabel!
    
    @IBOutlet weak var totalPlayed_countLabel: UILabel!
    @IBOutlet weak var goals_countLabel: UILabel!
    @IBOutlet weak var penaltyGoals_countLabel: UILabel!
    @IBOutlet weak var minuitesPrGame_countLabel: UILabel!
    @IBOutlet weak var accuratePasses_countLabel: UILabel!
    @IBOutlet weak var freeKick_countLabel: UILabel!
    @IBOutlet weak var yellowCard_countLabel: UILabel!
    @IBOutlet weak var redCard_countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func checkLocalisation() {
//        totalPlayerLabel.text = StringConstants.totalMatches.localized
//        goalsLabel.text = StringConstants.goals.localized
//        penaltyGoalsLabel.text = StringConstants.penaltyGoals.localized
//        minuitesPerGameLabel.text = StringConstants.minuitesPerGame.localized
//        accuratePassesLabel.text = StringConstants.accuratePasses.localized
//        freeKickLabel.text = StringConstants.freeKicksGoals.localized
//        yelloCarLabel.text = StringConstants.yellowCard.localized
//        redCardLabel.text = StringConstants.redCard.localized
    }
    
    func configuration(with statistics: PlayerDetailModel, cellForItemAt indexPath: IndexPath) {
        checkLocalisation()
        
        let leagueStatistic = statistics.data?.statistics?[indexPath.row]
        //leagueNameLabel.text = leagueStatistic?.league
        
        if let data = leagueStatistic?.data {
            for item in data {
                switch item.section {
                case StringConstants.matches.fixedLocaized:
                    if let matchData = item.data {
                        for matchItem in matchData {
                            if matchItem.key == StringConstants.totalPlayed.fixedLocaized {
                                totalPlayed_countLabel.text = matchItem.value
                            }
                            if matchItem.key == StringConstants.minuitesPerGame.fixedLocaized {
                                minuitesPrGame_countLabel.text = matchItem.value
                            }
                        }
                    }
                    
                case StringConstants.attacking.fixedLocaized:
                    if let attackingData = item.data {
                        for attackingItem in attackingData {
                            if attackingItem.key == StringConstants.goals.fixedLocaized {
                                goals_countLabel.text = attackingItem.value
                            }
                            if attackingItem.key == StringConstants.penaltyGoals.fixedLocaized {
                                penaltyGoals_countLabel.text = attackingItem.value
                            }
                            if attackingItem.key == StringConstants.freeKicksGoals.fixedLocaized {
                                freeKick_countLabel.text = attackingItem.value
                            }
                        }
                    }
                    
                case StringConstants.passes.fixedLocaized:
                    if let passesData = item.data {
                        for passesItem in passesData {
                            if passesItem.key == StringConstants.accuratePerGame.fixedLocaized {
                                accuratePasses_countLabel.text = passesItem.value
                            }
                        }
                    }
                    
                case StringConstants.cards.fixedLocaized:
                    if let cardsData = item.data {
                        for cardsItem in cardsData {
                            if cardsItem.key == StringConstants.yellow.fixedLocaized {
                                yellowCard_countLabel.text = cardsItem.value
                            }
                            if cardsItem.key == StringConstants.red.fixedLocaized {
                                redCard_countLabel.text = cardsItem.value
                            }
                        }
                    }
                    
                default:
                    break
                }
            }
        }
    }

}
