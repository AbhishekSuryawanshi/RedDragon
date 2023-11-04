//
//  PostTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 28/10/2023.
//

import UIKit

enum postType: String {
    case post = "POST"
    case poll = "POLL"
}

protocol PostTableCellDelegate: AnyObject {
    func postImageTapped(url: String)
    func pollAdded(postModel: SocialPost, answer: Int)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var matchBgView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    
    @IBOutlet weak var pollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pollView: UIView!
    @IBOutlet weak var pollTableView: UITableView!
    
    @IBOutlet weak var commentStackView: UIStackView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    weak var delegate:PostTableCellDelegate?
    var pollCount = 0
    var model = SocialPost()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nibInitialization()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func nibInitialization() {
        imageCollectionView.register(CellIdentifier.singleImageCollectionViewCell)
        pollTableView.register(CellIdentifier.socialPollTableViewCell)
    }
    
    func configure(_index: Int, model: SocialPost, detailPage:Bool = false) {
        self.model = model
        moreButton.isHidden = detailPage
        commentStackView.isHidden = model.type == "POLL" || detailPage
        
        userImageView.setImage(imageStr: model.userImage, placeholder: UIImage(named: "person.circle.fill"))
        userNameLabel.text = "\(model.firstName) \(model.lastName)"
        dateLabel.text = model.updatedTime.formatDate2(inputFormat: .hhmmaddMMMyyyy)
        imageBgView.isHidden = model.postImages.count == 0
        matchBgView.borderColor = .lightGray
        matchBgView.borderWidth = 0.3
        matchView.isHidden = true
        pollView.isHidden = model.type != "POLL"
        likeImageView.image = model.liked ? .likeSelected : .like
        likeCountLabel.text = "\(model.likeCount)"
        commentCountLabel.text = "\(model.commentCount)"
        if model.type == "POLL" {
            pollCount = model.option_1Count + model.option_2Count + model.option_3Count
            statusLabel.text = pollCount == 0 ? "" : (pollCount == 1 ? "\(pollCount) Vote" : "\(pollCount) Votes")
        } else {
            let statusCount = model.likeCount + model.commentCount
            statusLabel.text = statusCount == 0 ? "" : (statusCount == 1 ? "\(statusCount) Like/Comment" : "\(statusCount) Likes/Comments")
        }
        
        if model.type == "POLL" {
            pollViewHeightConstraint.constant = CGFloat(40 + (model.pollArray.count * 40))
            pollTableView.reloadData()
            contentLabel.text = model.descriptn
            
            //            let descriptn = model.descriptn == "_Test_" ? "" : model.descriptn
            //            contentLabel.text = descriptn
            //            questienLabel.text = model.question
            //            let pollCount = model.option_1Count + model.option_2Count + model.option_3Count
            //            let pollCountString = NSMutableAttributedString()
            //
            //            let pollDate = model.createdTime.toDate(inputFormat: .ddMMyyyyWithTimeZone)
            //            pollCountString.regular("\(pollCount) " + "vote".localized, size: 14).black(" • ", size: 18).regular("until".localized + " \(pollDate.numOfDaysFromToday()) " + "days".localized, size: 14)
            //            pollStatusLabel.attributedText = pollCountString
            //
            //            pollResultsStack.isHidden = model.userPoll.answer == 0
            //            pollButtonsStack.isHidden = !pollResultsStack.isHidden
            //            if model.userPoll.answer == 0 {
            //
            //                optionButton_1.setTitle(model.option_1, for: .normal)
            //                optionBTN_2.setTitle(model.option_2, for: .normal)
            //                optionBTN_3.setTitle("I don't know".localized, for: .normal)
            //            } else {
            //               // print("poll.... \(model.userPoll.answer)  \(pollCount)  1- \(model.option_1Count) 2- \(model.option_2Count) 3- \(model.option_3Count)")
            //                option_1Label.text = model.option_1
            //                let option1Percentg = CGFloat((model.option_1Count * 100) / pollCount)
            //                option_1CountLabel.text = "\(option1Percentg)%" // String(model.option_1Count) + " " + (model.option_1Count < 2 ? "vote".localized : "votes".localized)
            //                option_1WidthConstraint.constant = (option1Percentg * 0.01) * (screenWidth - 60)
            //
            //                option_2Label.text = model.option_2
            //                let option2Percentg = CGFloat((model.option_2Count * 100) / pollCount)
            //                option_2CountLabel.text = "\(option2Percentg)%" // String(model.option_2Count) + " " + (model.option_2Count < 2 ? "vote".localized : "votes".localized)
            //                option_2WidthConstraint.constant = (option2Percentg * 0.01) * (screenWidth - 60)
            //
            //                option_3Label.text = "I don't know".localized
            //                let option3Percentg = CGFloat((model.option_3Count * 100) / pollCount)
            //                option_3CountLabel.text = "\(option3Percentg)%" // String(model.option_3Count) + " " + (model.option_3Count < 2 ? "vote".localized : "votes".localized)
            //                option_3WidthConstraint.constant = (option3Percentg * 0.01) * (screenWidth - 60)
            //            }
            //            let questienHeight = model.question.heightOfString2(width: screenWidth - 40, font: fontRegular(16))
            //            let pollHeight = model.type == "POLL" ? (questienHeight + (model.userPoll.answer == 0 ? 200 : 185)) : 0
            //            pollHeightConstarint.constant = pollHeight
        } else {
            
            //POST
            if let content = model.contentHtml.attributedHtmlString {
                contentLabel.text = content.string
            }
            //POST Image
            if model.postImages.count > 0 {
                imageCollectionView.reloadData()
                setfeedImageCVLayout(collectionview: self.imageCollectionView, imageCount: model.postImages.count)
                imageBgView.isHidden = model.postImages.count == 0
                imageCollectionView.reloadData()
            } else {
                
            }
            
            //POST Match
            if model.matchDetail != "" {
                matchView.isHidden = false
                leagueLabel.text = model.matchModel.league.name
                leagueImageView.setImage(imageStr: model.matchModel.league.logo, placeholder: UIImage.noLeague)
                matchDateLabel.text = model.matchModel.matchUnixTime.formatDate(outputFormat: dateFormat.hhmmaddMMMyyyy2, today: true)
                homeImageView.setImage(imageStr: model.matchModel.homeTeam.logo, placeholder: UIImage.noTeam)
                awayImageView.setImage(imageStr: model.matchModel.awayTeam.logo, placeholder: UIImage.noTeam)
                homeNameLabel.text = UserDefaults.standard.language == "en" ? model.matchModel.homeTeam.enName : model.matchModel.homeTeam.cnName
                awayNameLabel.text = UserDefaults.standard.language == "en" ? model.matchModel.awayTeam.enName : model.matchModel.awayTeam.cnName
                scoreLabel.text = "\(model.matchModel.homeScores.first ?? 0) - \(model.matchModel.awayScores.first ?? 0)"
            } else {
                matchView.isHidden = true
            }
        }
        
        moreButton.tag = _index
        likeButton.tag = _index
        commentButton.tag = _index
        shareButton.tag = _index
    }
}

// MARK: - CollectionView Delegates
extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.singleImageCollectionViewCell, for: indexPath) as! SingleImageCollectionViewCell
        cell.imageImageView.setImage(imageStr: model.postImages[indexPath.row])
        cell.imageImageView.cornerRadius = 7
        cell.imageImageView.clipsToBounds = true
        cell.closeBgView.isHidden = true
        return cell
    }
}

extension PostTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.postImageTapped(url: model.postImages[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        return cellSize
    }
}

// MARK: - TableView Delegates
extension PostTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.pollArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.socialPollTableViewCell, for: indexPath) as! SocialPollTableViewCell
        cell.configure(type: model.userPoll.answer == 0 ? .pollQuestien : .pollAnswer, poll: model.pollArray[indexPath.row], pollCount: pollCount)
        return cell
    }
}

extension PostTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if model.userPoll.answer == 0 {
            delegate?.pollAdded(postModel: model, answer: indexPath.row + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}
