//
//  PostMatchesVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit

protocol PostMatchesVCDelegate: AnyObject {
    func matchSelected(match: SocialMatch)
}

class PostMatchesVC: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var selectMatchLabeL: UILabel!
    
    weak var delegate: PostMatchesVCDelegate?
    var selectedMatch = SocialMatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func initialSettings() {
        nibInitialization()
        setupGestureRecognizers()
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshForLocalization()
        
    }
    func nibInitialization() {
        listTableView.register(CellIdentifier.matchTableViewCell)
    }
    
    func refreshForLocalization() {
        selectMatchLabeL.text = "Select match".localized
    }

    private func setupGestureRecognizers() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        delegate?.matchSelected(match: selectedMatch)
    }
    
    // MARK: - Button Actions
    
    @IBAction func downBTNTapped(_ sender: UIButton) {
        
    }
}

// MARK: - TableView Delegate
extension PostMatchesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SocialMatchVM.shared.matchArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.matchEmptyAlert)
        } else {
            tableView.restore()
        }
        return SocialMatchVM.shared.matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.matchTableViewCell, for: indexPath) as! MatchTableViewCell
        cell.setCellValues(model: SocialMatchVM.shared.matchArray[indexPath.row])
        return cell
        
    }
}

extension PostMatchesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMatch = SocialMatchVM.shared.matchArray[indexPath.row]
        self.downBTNTapped(UIButton())
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

