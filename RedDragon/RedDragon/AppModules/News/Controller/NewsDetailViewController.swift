//
//  NewsDetailViewController.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import UIKit

final class NewsDetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    let viewModel: NewsDetailViewModel
    
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
    
}

private extension NewsDetailViewController {

    func build() {
        bind()
        configureViews()
    }
    
    func bind() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(NewsDetailTableViewCell.nib_Name, forCellReuseIdentifier: NewsDetailTableViewCell.reuseIdentifier)
        
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    func configureViews() {
        detailTableView.reloadData()
    }

}

extension NewsDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(
            withIdentifier: NewsDetailTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewsDetailTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(with: NewsDetailCellViewModel(model: viewModel.model))
        return cell
    }
    
}
