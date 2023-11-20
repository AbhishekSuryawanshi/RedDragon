//
//  MeetHomeVC.swift
//  RedDragon
//
//  Created by iOS Dev on 20/11/2023.
//

import UIKit
import Shuffle
import Combine

enum meetHeaderSegment: String, CaseIterable {
    case home = "Home"
    case explore = "Explore"
    case event = "Event"
    case chat = "Chat"
}

class MeetHomeVC: UIViewController {
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var cardStack: SwipeCardStack!
    @IBOutlet weak var viewContainerForButtons: UIView!
    
    var selectedSegment: meetHeaderSegment = .home
    var cancellable = Set<AnyCancellable>()
    private var userVM: MeetUserViewModel?
    var arrayOfUsers = [MeetUser]()
   
    private let cardModels = [
      TinderCardModel(name: "Michelle",
                      age: 26,
                      occupation: "Graphic Designer",
                      image: UIImage(named: "michelle")),
      TinderCardModel(name: "Joshua",
                      age: 27,
                      occupation: "Business Services Sales Representative",
                      image: UIImage(named: "joshua")),
      TinderCardModel(name: "Daiane",
                      age: 23,
                      occupation: "Graduate Student",
                      image: UIImage(named: "daiane")),
      TinderCardModel(name: "Julian",
                      age: 25,
                      occupation: "Model/Photographer",
                      image: UIImage(named: "julian")),
      TinderCardModel(name: "Andrew",
                      age: 26,
                      occupation: nil,
                      image: UIImage(named: "andrew")),
      TinderCardModel(name: "Bailey",
                      age: 25,
                      occupation: "Software Engineer",
                      image: UIImage(named: "bailey")),
      TinderCardModel(name: "Rachel",
                      age: 27,
                      occupation: "Interior Designer",
                      image: UIImage(named: "rachel"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addActivityIndicator()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        cardStack.delegate = self
        cardStack.dataSource = self
        nibInitialization()
        makeNetworkCall()
        fetchMeetUserViewModel()
    }

    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        userVM = MeetUserViewModel()
        userVM?.fetchMeetUserListAsyncCall()
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeDislikeButtonTapped(_ sender: UIButton) {
        if sender.tag == 1 {  //Dislike User
            cardStack.swipe(.left, animated: true)
            
        }else { // Like User
            cardStack.swipe(.right, animated: true)
        }
    }
}

extension MeetHomeVC {
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    ///fetch view model for user list
    func fetchMeetUserViewModel() {
        userVM?.showError = { [weak self] error in
                self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
            }
        userVM?.displayLoader = { [weak self] value in
                self?.showLoader(value)
            }
        userVM?.$responseData
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(receiveValue: { [weak self] userList in
                    self?.execute_onResponseData(userList!)
                })
                .store(in: &cancellable)
        }
        
        func execute_onResponseData(_ userList: MeetUserListModel) {
            arrayOfUsers = userList.response?.data ?? []
            cardStack.reloadData()
        }
}

// MARK: - CollectionView Delegates
extension MeetHomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetHeaderSegment.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureUnderLineCell(title: meetHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == meetHeaderSegment.allCases[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = meetHeaderSegment.allCases[indexPath.row]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selected = selectedSegment == meetHeaderSegment.allCases[indexPath.row]
        return CGSize(width: meetHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 26, height: 50)
    }
    
}

extension MeetHomeVC: SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
      let card = SwipeCard()
      card.footerHeight = 80
      card.swipeDirections = [.left, .up, .right]
      for direction in card.swipeDirections {
        card.setOverlay(SwipeCardOverlay(direction: direction), forDirection: direction)
      }
      let model = arrayOfUsers[index]
      card.content = SwipeCardContentView(withImageURLString: model.profileImg ?? "")
      card.footer = SwipeCardFooterView(withTitle: "\(model.name ?? "")", subtitle: model.location)

      return card
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
      return arrayOfUsers.count
    }

    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
      print("Swiped all cards!")
      viewContainerForButtons.isHidden = true
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
      print("Swiped \(direction) on \(cardModels[index].name)")
    }

    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
      print("Card tapped")
    }
}
