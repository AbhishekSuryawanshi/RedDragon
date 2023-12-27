//
//  NewsModuleVC.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
//

import UIKit
import Combine

enum NewsHeaders: String, CaseIterable {
    case news   = "News"
    case gossip = "Gossip"
}

class NewsModuleVC: UIViewController {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    var sportsTypeArray: [SportsType] = []
    var sportType: SportsType = .football
    var contentType: NewsHeaders = .news
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTextField.placeholder = "Search".localized
    }
    
    func initialSettings() {
        nibInitialization()
        setView()
        NotificationCenter.default.addObserver(self, selector: #selector(pushViewController), name: .moveToNewsDetail, object: nil)
    }
    
    func setView() {
        if contentType == .gossip {
            sportsTypeArray = [.football, .cricket, .tennis, .hockey, .athletics, .motorsport, .races, .eSports, .others]
            ViewEmbedder.embed(withIdentifier: "GossipVC", storyboard: UIStoryboard(name: StoryboardName.gossip, bundle: nil)
                               , parent: self, container: containerView) { vc in
                let vc = vc as! GossipVC
                vc.sportType = self.sportType
            }
        } else {
            searchTextField.placeholder = "Search".localized
            sportsTypeArray = [.football, .tennis, .eSports, .basketball]
            ViewEmbedder.embedXIBController(childVC: NewsVC(viewModel: NewsViewModel(sportType: sportType)), parentVC: self, container: containerView)
        }
        sportsCollectionView.reloadData()
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        sportsCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
    }
    
    @objc func pushViewController(notification: Notification) {
        guard let model = notification.userInfo?["NewsDetails"] as? NewsDetail else { return }
        let viewModel = NewsDetailViewModel(model: model)
        viewModel.fetchDetailsAsyncCall(newsId: model.id ?? 0)
        viewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                viewModel.onSuccess(response: response)
                self?.navigationController?.pushViewController(NewsDetailViewController(viewModel: viewModel), animated: true)
            })
            .store(in: &cancellable)
        
    }
    
    func searchData(text: String) {
        let dataDict:[String: Any] = ["text": text]
        NotificationCenter.default.post(name: .newsSearch, object: nil, userInfo: dataDict)
    }
}

// MARK: - CollectionView Delegates
extension NewsModuleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == headerCollectionView {
            return NewsHeaders.allCases.count
        } else {
            return sportsTypeArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        
        if collectionView == headerCollectionView {
            cell.configureUnderLineCell(title: NewsHeaders.allCases[indexPath.row].rawValue.localized, selected: NewsHeaders.allCases[indexPath.row] == contentType)
        } else {
            cell.configureUnderLineCell(title: sportsTypeArray[indexPath.row].rawValue.localized, selected: sportsTypeArray[indexPath.row] == sportType, textColor: .black, fontSize: 15)
        }
        return cell
    }
}

extension NewsModuleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            contentType = NewsHeaders.allCases[indexPath.row]
        } else {
            sportType = sportsTypeArray[indexPath.row]
        }
        collectionView.reloadData()
        setView()
    }
}

extension NewsModuleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == headerCollectionView {
            return CGSize(width: (screenWidth - 70) / 2, height: 60)
        } else {
            let selected = sportsTypeArray[indexPath.row] == sportType
            return CGSize(width: sportsTypeArray[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : fontSemiBold(15)]).width + 30, height: 40)
        }
    }
}

// MARK: - TextField Delegate
extension NewsModuleVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let searchText = text.replacingCharacters(in: textRange,with: string)
            searchData(text: searchText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchData(text: searchTextField.text!)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        searchData(text: searchTextField.text!)
        return true
    }
}
