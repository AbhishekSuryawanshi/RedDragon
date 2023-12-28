//
//  NewsDetailViewController.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import UIKit
import Combine

final class NewsDetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    let viewModel: NewsDetailViewModel
    var allCommentsArray: [Comment] = []
    var commentsArray: [Comment] = []
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        build()
    }
    
    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "NewsDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func commentButtonTapped(_ sender: UIButton) {
        navigateToViewController(NewsCommentsVC.self, storyboardName: StoryboardName.gossip, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.sectionId = "\(self.viewModel.model.id ?? 0)"
            vc.newsTitle = self.viewModel.model.title ?? ""
            vc.commentsArray = self.allCommentsArray
        }
    }
    
}

private extension NewsDetailViewController {

    func build() {
        bind()
        configureViews()
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            CommentListVM.shared.getCommentsAsyncCall(sectionId: "\(viewModel.model.id ?? 0)")
            fetchCommentsViewModel()
        }
    }
    
    func bind() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(NewsDetailTableViewCell.nib_Name, forCellReuseIdentifier: NewsDetailTableViewCell.reuseIdentifier)
        detailTableView.register(NewsDetailCommendableTableViewCell.nib_Name, forCellReuseIdentifier: NewsDetailCommendableTableViewCell.reuseIdentifier)
        detailTableView.register(CommentTableViewCell.nib_Name, forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier)
        
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    func configureViews() {
        detailTableView.reloadData()
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func fetchCommentsViewModel() {
        ///fetch comment list
        CommentListVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        CommentListVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        CommentListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.allCommentsArray = dataResponse.data ?? []
                    self?.commentsArray = Array((dataResponse.data ?? []).prefix(2))
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
                self?.detailTableView.reloadData()
            })
            .store(in: &cancellable)
    }

}

extension NewsDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if commentsArray.count > 0 {
            return 3
        }
        return ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            return commentsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = detailTableView.dequeueReusableCell(
                withIdentifier: NewsDetailTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? NewsDetailTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(with: NewsDetailCellViewModel(model: viewModel.model))
            return cell
            
        case 1:
            guard let cell = detailTableView.dequeueReusableCell(
                withIdentifier: NewsDetailCommendableTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? NewsDetailCommendableTableViewCell else { return UITableViewCell() }
            
            cell.commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
            return cell
            
        default:
            guard let cell = detailTableView.dequeueReusableCell(
                withIdentifier: CommentTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? CommentTableViewCell else { return UITableViewCell() }
            
            cell.deleteButton.isHidden = true
            cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row)
            return cell
        }
        
    }
    
}
