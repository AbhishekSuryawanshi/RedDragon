//
//  GameViewController.swift
//  RedDragon
//
//  Created by QASR02 on 08/12/2023.
//

import UIKit
import Combine
import RealmSwift
import SDWebImage

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
    
    @IBOutlet weak var plusOneScore_forUser_label: UILabel!
    @IBOutlet weak var plusOneScore_forOpponent_label: UILabel!
    @IBOutlet weak var plusOneScore_forUser_constraints: NSLayoutConstraint!
    @IBOutlet weak var plusOneScore_forOpponent_constraints: NSLayoutConstraint!
    @IBOutlet weak var useCardButton: UIButton!
    @IBOutlet weak var useCardButtonView: UIView!
    
    var againstComputer: Bool?
    var allPlayersVM: AllFootballPlayersViewModel?
    var cancellable = Set<AnyCancellable>()
    var playersIDs: [Int] = []
    var opponent_playersIDs: [Int] = []
    var opponentUserName: String?
    var opponentUserProfileImage: String?
    var opponentUserID: Int?
    var team: MyTeam?
    var players: [RealmPlayerData]?
    var opponentPlayer: [RealmPlayerData]?
    var selectedIndexPath: IndexPath?
    var isUserTurn = Bool.random()
    var selectedPlayerID: String?
    var isUserTurnFirst: Bool?
    
    var userSelectedScore = String()
    var opponentSelectedScore = String()
    var opponentSelectedAbility = String()
    
    var userScore = Int()
    var opponentScore = Int()
    
    var countdownValue = 0
    var countdownTimer: Timer?
    var roundCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocalisation()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
  
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func abilityButtonPressed(_ sender: UIButton) {
        if let abilityType = AbilityType(rawValue: sender.tag) {
            let (countLabelText, labelText) = updateViewForAbility(abilityType)
            //check: if opponent has first turn and user has selected same ability to play
            if isUserTurnFirst == false {
                if opponentSelectedAbility != labelText || countLabelText == "--" {
                    useCardButtonView.alpha = 0.4
                    useCardButton.isHidden = true
                    return
                }
            }
            //update final card value
            userSelectedScore = countLabelText
            yourFinalCardAbilityScoreLabel.text = countLabelText
            youFinalCardAbilityNameLabel.text = labelText
            useCardButtonView.alpha = 1
            useCardButton.isHidden = false
        }
    }
    
    @IBAction func useCardButton(_ sender: Any) {
        if useCardButtonView.isHidden == true {
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, animations: { [self] in
            useCardButtonView.alpha = 0.4
            useCardButton.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: { [self] finished in
            resetColors()
            if isUserTurnFirst == true {
                checkActionOnCountdown()
            }
            for id_player in 0..<(players?.count ?? 0) {
                if selectedPlayerID == players?[id_player].id {
                    players?.remove(at: id_player)
                    resetScoreLabels()
                    break
                }
            }
            userPlayersCollectionView.reloadData()
        })
        UIView.transition(with: yourFinalCardView, duration: 1.0, options: .transitionCrossDissolve) { [self] in
            yourFinalCardView.alpha = 1
            //checkActionOnCountdown()
        }
        ///if the game has been started from user side
        if isUserTurnFirst == true {
            userTurnToPlayFirst()
        }
        ///opponent started game first
        else {
            checkOpponentCard()
        }
    }
}

/// __ supportive functionality
extension GameViewController {
    func checkLocalisation() {
        yourNameLabel.text = StringConstants.you.localized
        youTurnLabel.text = StringConstants.yourTurn.localized
        opponentLabel.text = StringConstants.opponent.localized
        ratingLabel.text = StringConstants.rating.localized
        attackingLabel.text = StringConstants.attacking.localized
        technicalLabel.text = StringConstants.technical.localized
        defendingLabel.text = StringConstants.defending.localized
        tacticalLabel.text = StringConstants.tactical.localized
        creativityLabel.text = StringConstants.creativity.localized
    }
    
    func resetScoreLabels() {
        ratingCountLabel.text = "--"
        attackingCountLabel.text = "--"
        technicalCountLabel.text = "--"
        defendingCountLabel.text = "--"
        tacticalCountLabel.text = "--"
        creativityCountLabel.text = "--"
    }
    
    func setupUI() {
        getUsersPlayersDetails()
        statisticViewBorder()
        setAlphaValue()
        shufflePlayerToPlay()
        beginingValue()
        opponentIsUser()
    }
    
    func getUsersPlayersDetails() {
        allPlayersVM = AllFootballPlayersViewModel.shared
        players = [RealmPlayerData]()
        players = allPlayersVM?.getPlayerDataForIDs(playersIDs)
    }
    
    func statisticViewBorder() {
        viewShadow(statisticsView, color: UIColor(displayP3Red: 205/255, green: 229/255, blue: 112/255, alpha: 1), opacity: 0.5)
    }
    
    func setAlphaValue() {
        useCardButtonView.alpha = 0.4
        useCardButton.isHidden = true
        yourFinalCardView.alpha = 0
        opponentFinalCardView.alpha = 0
        plusOneScore_forUser_label.alpha = 0
        plusOneScore_forOpponent_label.alpha = 0
    }
    
    func shufflePlayerToPlay() {
        startCountdown()
        roundCount += 1
        showRoundCount()
        
        let userTurnAlpha: CGFloat = isUserTurn ? 1 : 0
        let opponentTurnAlpha: CGFloat = isUserTurn ? 0 : 1
        
        youTurnLabel.alpha = userTurnAlpha
        yourTurnCountdownLabel.alpha = userTurnAlpha
        opponentLabel.alpha = opponentTurnAlpha
        opponentCountdownLabel.alpha = opponentTurnAlpha
        
        statisticsView.isUserInteractionEnabled = isUserTurn
        userPlayersCollectionView.isUserInteractionEnabled = isUserTurn
        
        yourTurnView.backgroundColor = isUserTurn ? UIColor(red: 255/255, green: 224/255, blue: 138/255, alpha: 1) : UIColor.white
        opponentTurnView.backgroundColor = isUserTurn ? UIColor.white : UIColor(red:  255/255, green: 224/255, blue: 138/255, alpha: 1)
        
        resetColors()
    }
    
    func showRoundCount() {
        switch roundCount {
        case 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21:
            yourFinalCardView.alpha = 0
            opponentFinalCardView.alpha = 0
        default:
            break
        }
        let roundIndex = (roundCount - 1) / 2 + 1
        roundCountLabel.text = "\(StringConstants.round.localized) \(roundIndex) / 11"
    }
    
    func beginingValue() {
        self.view.addSubview(Loader.activityIndicator)
        userPlayersCollectionView.allowsMultipleSelection = false
        statisticsView.isUserInteractionEnabled = false
        roundCountLabel.text = "\(StringConstants.round.localized) 1 / 11"
        isUserTurnFirst = isUserTurn
        yourScoreLabel.text = "\(StringConstants.score.localized) 0"
        opponentScoreLabel.text = "\(StringConstants.score.localized) 0"
        if isUserTurn == false {
            opponentTurnToPlayFirst()
        }
    }
    
    func userTurnToPlayFirst() {
        plusOneScoreLabelConstants()
        fetchRandomOpponentPlayer()
        
        if youFinalCardAbilityNameLabel.text == StringConstants.rating.localized {
            opponentFinalCardAbilityNameLabel.text = StringConstants.rating.localized
            opponentFinalCardAbilityScoreLabel.text = opponentPlayer?[0].rating ?? ""
            opponentSelectedScore = opponentPlayer?[0].rating ?? ""
        } else {
            for ability in 0..<(opponentPlayer?[0].ability.count ?? 0) {
                if youFinalCardAbilityNameLabel.text == opponentPlayer?[0].ability[ability].name.localized {
                    opponentFinalCardAbilityNameLabel.text = opponentPlayer?[0].ability[ability].name.localized
                    opponentFinalCardAbilityScoreLabel.text = "\(opponentPlayer?[0].ability[ability].value ?? 0)"
                    opponentSelectedScore = "\(opponentPlayer?[0].ability[ability].value ?? 0)"
                }
            }
        }
        opponentFinalCardPlayerImage.sd_setImage(with: URL(string: opponentPlayer?[0].photo ?? ""))
        opponentFinalCardPlayerNameLabel.text = opponentPlayer?[0].name
        
        if againstComputer == false {
            opponentPlayer?.removeFirst()
        }
        
        let randomCount = Double.random(min: 02.00, max: 6.00)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomCount) { [self] in
            UIView.transition(with: opponentFinalCardView, duration: 1.0, options: .transitionCrossDissolve) { [self] in
                opponentFinalCardView.alpha = 1
                
                compareAndDecideWinner()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                    checkActionOnCountdown()
                }
            }
        }
    }
    
    func checkOpponentCard() {
        plusOneScoreLabelConstants()
        compareAndDecideWinner()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
            checkActionOnCountdown()
            opponentTurnToPlayFirst()
        }
    }
    
    func opponentTurnToPlayFirst() {
        fetchRandomOpponentPlayer()
        
        let randomCount = Double.random(min: 03.00, max: 10.00)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomCount) { [self] in
            UIView.transition(with: opponentFinalCardView, duration: 1.0, options: .transitionCrossDissolve) { [self] in
                opponentFinalCardView.alpha = 1
                fetchRandomAbility_opponentPlayer()
            }
        }
    }
    
    func fetchRandomAbility_opponentPlayer() {
        let gameEnd = UserDefaults.standard.bool(forKey: "gameEnd")
        if gameEnd { return }
        
        let pickRandom = [StringConstants.rating.localized, StringConstants.attacking.localized, StringConstants.technical.localized, StringConstants.defending.localized, StringConstants.tactical.localized, StringConstants.creativity.localized]
        
        let randomValue = pickRandom.randomElement()
        if randomValue == StringConstants.rating.localized {
            opponentFinalCardAbilityNameLabel.text = StringConstants.rating.localized
            opponentFinalCardAbilityScoreLabel.text = opponentPlayer?[0].rating ?? ""
            opponentSelectedScore = opponentPlayer?[0].rating ?? ""
            opponentSelectedAbility = StringConstants.rating.localized
        } else {
            for ability in 0..<(opponentPlayer?[0].ability.count ?? 0) {
                if randomValue == opponentPlayer?[0].ability[ability].name.localized {
                    opponentFinalCardAbilityNameLabel.text = opponentPlayer?[0].ability[ability].name.localized
                    opponentFinalCardAbilityScoreLabel.text = "\(opponentPlayer?[0].ability[ability].value ?? 0)"
                    opponentSelectedScore = "\(opponentPlayer?[0].ability[ability].value ?? 0)"
                    opponentSelectedAbility = (opponentPlayer?[0].ability[ability].name.localized)!
                }
            }
        }
        opponentFinalCardPlayerImage.sd_setImage(with: URL(string: opponentPlayer?[0].photo ?? ""))
        opponentFinalCardPlayerNameLabel.text = opponentPlayer?[0].name
        
        if againstComputer == false {
            opponentPlayer?.removeFirst()
        }
        checkActionOnCountdown()
    }
    
    func fetchRandomOpponentPlayer() {
        if againstComputer == true {
            //get random Player opponent
            guard let allPlayers = allPlayersVM?.allPlayers?.data else {
                return
            }
            let randomIndex = Int.random(in: 0..<allPlayers.count)
            if let opponentPlayerID = Int(allPlayers[randomIndex].id ) {
                opponentPlayer = allPlayersVM?.getPlayerDataForIDs([opponentPlayerID])
            }
        }
    }
    
    func opponentIsUser() {
        if againstComputer == false {
            opponentNamelabel.text = opponentUserName
            opponentProfileImage.sd_setImage(with: URL(string: opponentUserProfileImage ?? ""))
            ///get shuffled opponent player from player ID's
            opponentPlayer = [RealmPlayerData]()
            let opponentPlayer_ids = allPlayersVM?.getPlayerDataForIDs(opponent_playersIDs)
            opponentPlayer = opponentPlayer_ids?.shuffled()
        } else {
            opponentNamelabel.text = StringConstants.computer.localized
        }
    }
    
    func plusOneScoreLabelConstants() {
        plusOneScore_forUser_label.alpha = 0
        plusOneScore_forOpponent_label.alpha = 0
        plusOneScore_forOpponent_constraints.constant = 8
        plusOneScore_forUser_constraints.constant = 8
    }
    
    func compareAndDecideWinner() {
        //compare the value and check the winner
        let userPlayerValue = Double(userSelectedScore)
        let opponentPlayerValue = Double(opponentSelectedScore)
        
        if userPlayerValue ?? 0 < opponentPlayerValue ?? 0 {
            plusOneScore_forOpponent_label.alpha = 1
            
            UIView.animate(withDuration: 3.0, delay: 1.0, animations: { [self] in
                plusOneScore_forOpponent_constraints.constant = 100
                plusOneScore_forOpponent_label.alpha = 0
                opponentScore = opponentScore + 1
                opponentScoreLabel.text = "\(StringConstants.score.localized) \(opponentScore)"
                self.view.layoutIfNeeded()
            }, completion: { [self] finish in
                plusOneScore_forOpponent_constraints.constant = 8
            })
        }
        else if userPlayerValue ?? 0 > opponentPlayerValue ?? 0 {
            plusOneScore_forUser_label.alpha = 1
            
            UIView.animate(withDuration: 3.0, delay: 1.0, animations: { [self] in
                plusOneScore_forUser_constraints.constant = 100
                plusOneScore_forUser_label.alpha = 0
                userScore = userScore + 1
                yourScoreLabel.text = "\(StringConstants.score.localized) \(userScore)"
                self.view.layoutIfNeeded()
            }, completion: { [self] finish in
                plusOneScore_forUser_constraints.constant = 8
            })
        }
        else if userPlayerValue ?? 0 == opponentPlayerValue ?? 0 {
            //print("match is draw")
        }
    }
}

//MARK: Update Ability selection
extension GameViewController {
    
    enum AbilityType: Int {
        case rating = 0, attacking, technical, defending, tactical, creativity
    }
    
    func updateViewForAbility(_ type: AbilityType) -> (String, String) {
        let clearColor = UIColor.clear
        let selectedColor = UIColor(red: 205/255, green: 229/255, blue: 112/255, alpha: 1)
        let unselectedColor = UIColor.lightGray
        
        let count_labels: [UILabel] = [ratingCountLabel, attackingCountLabel, technicalCountLabel, defendingCountLabel, tacticalCountLabel, creativityCountLabel]
        let labels: [UILabel] = [ratingLabel, attackingLabel, technicalLabel, defendingLabel, tacticalLabel, creativityLabel]
        let views: [UIView] = [ratingView, attackingView, technicalView, defendingView, tacticalView, creativityView]
        
        for (index, view) in views.enumerated() {
            if let abilityType = AbilityType(rawValue: index) {
                view.backgroundColor = abilityType == type ? selectedColor : clearColor
                count_labels[index].textColor = abilityType == type ? UIColor.black : selectedColor
                labels[index].textColor = abilityType == type ? UIColor.black : unselectedColor
            }
        }
        
        let countLabel = count_labels[type.rawValue]
        let labelText = labels[type.rawValue]
        
        return (countLabel.text ?? "", labelText.text ?? "")
    }
    
    func resetColors() {
        UIView.animate(withDuration: 0.2, delay: 0, animations: { [self] in
            //useCardButtonView.alpha = 1
            useCardButton.isHidden = false
            self.view.layoutIfNeeded()
        })
        let clearColor = UIColor.clear
        let defaultTextColor = UIColor(red: 205/255, green: 229/255, blue: 112/255, alpha: 1)
        let unselectedColor = UIColor.lightGray
        
        let count_labels: [UILabel] = [ratingCountLabel, attackingCountLabel, technicalCountLabel, defendingCountLabel, tacticalCountLabel, creativityCountLabel]
        let labels: [UILabel] = [ratingLabel, attackingLabel, technicalLabel, defendingLabel, tacticalLabel, creativityLabel]
        let views: [UIView] = [ratingView, attackingView, technicalView, defendingView, tacticalView, creativityView]
        
        for (index, view) in views.enumerated() {
            view.backgroundColor = clearColor
            count_labels[index].textColor = defaultTextColor
            labels[index].textColor = unselectedColor
        }
        useCardButtonView.alpha = 0.4
        useCardButton.isHidden = true
    }
    
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = players
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.userPlayerCell, for: indexPath) as! UserPlayersCollectionCell
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.imageView.sd_setImage(with: URL(string: data?[indexPath.item].photo ?? ""))
        cell.nameLabel.text = data?[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isUserTurn {
            resetScoreLabels()
            
            userPlayersCollectionView.isUserInteractionEnabled = true
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
               selectedIndexPath != indexPath {
                collectionView.deselectItem(at: selectedIndexPath, animated: true)
            }
            
            selectedPlayerID = players?[indexPath.item].id
            
            //update final Card
            yourFinalCardPlayerImage.sd_setImage(with: URL(string: players?[indexPath.item].photo ?? ""))
            yourFinalCardPlayerNameLabel.text = players?[indexPath.item].name
            
            statisticsView.isUserInteractionEnabled = true
            resetColors()
            
            UIView.transition(with: statisticsView, duration: 0.5, options: .transitionFlipFromBottom) { [self] in
                if let player = players?[indexPath.item] {
                    ratingCountLabel.text = player.rating
                    updateAbilityLabel(ability: player.ability, label: attackingCountLabel, abilityName: "Attacking")
                    updateAbilityLabel(ability: player.ability, label: technicalCountLabel, abilityName: "Technical")
                    updateAbilityLabel(ability: player.ability, label: defendingCountLabel, abilityName: "Defending")
                    updateAbilityLabel(ability: player.ability, label: tacticalCountLabel, abilityName: "Tactical")
                    updateAbilityLabel(ability: player.ability, label: creativityCountLabel, abilityName: "Creativity")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width/3 - 10, height: 150)
    }
    
    func updateAbilityLabel(ability: List<RealmAbility>, label: UILabel, abilityName: String) {
        if let targetAbility = ability.first(where: { $0.name == abilityName }) {
            label.text = "\(targetAbility.value ?? 0)"
        }
    }
    
}


//MARK: Countdown functionality
extension GameViewController {
    
    func startCountdown() {
        countdownTimer?.invalidate()
        countdownValue = 0 //starts from 0 seconds
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if self.countdownValue < 45 { // Stop at 45 seconds
                self.countdownValue += 1
                self.updateCountdownLabel()
            }
            else if self.countdownValue == 45 {
                customAlertView(title: StringConstants.youThere.localized, description: StringConstants.itsYourTurn.localized, image: ImageConstants.alertImage)
                timer.invalidate()
            }
            else {
                timer.invalidate()
                checkActionOnCountdown()
            }
        }
        countdownTimer?.fire()
    }
    
    func updateCountdownLabel() {
        let minutes = countdownValue / 60
        let seconds = countdownValue % 60
        
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        
        if isUserTurn {
            yourTurnCountdownLabel.text = formattedTime
        } else {
            opponentCountdownLabel.text = formattedTime
        }
    }
    
    func checkActionOnCountdown() {
        if roundCount < 22 {
            isUserTurn.toggle()
            self.shufflePlayerToPlay()
            UserDefaults.standard.set(false, forKey: "gameEnd")
        } else {
            
            let gameEnd = UserDefaults.standard.bool(forKey: "gameEnd")
            
            if gameEnd { return }
            
            countdownTimer?.invalidate()
            userPlayersCollectionView.reloadData()
            userPlayersCollectionView.allowsMultipleSelection = false
            statisticsView.isUserInteractionEnabled = false
            
            UserDefaults.standard.set(true, forKey: "gameEnd")
            
//            if userScore > opponentScore {
//                navigateToViewController(WinViewController.self, storyboardName: StoryboardName.cardGamePopup) { [self] vc in
//                    vc.score = userScore
//                    vc.againstComputer = againstComputer ?? false
//                    if againstComputer == false {
//                        vc.opponentUserID = opponentUserID //pass opponent user id here
//                    }
//                }
//            } else {
//                navigateToViewController(LossViewController.self, storyboardName: StoryboardName.cardGamePopup) { [self] vc in
//                    vc.score = userScore
//                    vc.againstComputer = againstComputer ?? false
//                    if againstComputer == false {
//                        vc.opponentUserID = opponentUserID //pass opponent user id here
//                    }
//                }
//            }
        }
    }
    
}
