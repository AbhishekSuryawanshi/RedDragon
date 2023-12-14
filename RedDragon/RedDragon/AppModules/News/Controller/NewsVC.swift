//
//  NewsVC.swift
//  RedDragon
//
//  Created by Abdullah on 29/11/2023.
//

import UIKit
import Combine

final class NewsVC: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    private var cancellable = Set<AnyCancellable>()
    let viewModel: NewsViewModel
    let videoViewModel: NewsVideoViewModel
    var pageNo = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        build()
    }
    
    init(
        viewModel: NewsViewModel,
        videoViewModel: NewsVideoViewModel = NewsVideoViewModel()
    ) {
        self.viewModel = viewModel
        self.videoViewModel = videoViewModel
        
        super.init(nibName: "NewsVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NewsVC {
    
    func build() {
        bind()
        configureViews()
        fetchNewsList()
    }
    
    func bind() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.register(NewsBannerTableViewCell.nib_Name, forCellReuseIdentifier: NewsBannerTableViewCell.reuseIdentifier)
        newsTableView.register(TrendingNewsParentTableViewCell.nib_Name, forCellReuseIdentifier: TrendingNewsParentTableViewCell.reuseIdentifier)
        newsTableView.register(LatestNewsTableViewCell.nib_Name, forCellReuseIdentifier: LatestNewsTableViewCell.reuseIdentifier)
        newsTableView.register(NewsVideoTableViewCell.nib_Name, forCellReuseIdentifier: NewsVideoTableViewCell.reuseIdentifier)
        newsTableView.register(NewsHeaderTableViewCell.nib_Name, forCellReuseIdentifier: NewsHeaderTableViewCell.reuseIdentifier)
    }
    
    func configureViews() {
        
    }
    
    func fetchNewsList() {
        startLoader()
        viewModel.fetchNewsDataAsyncCall(page: pageNo, keyword: "/\(viewModel.sportType.rawValue)")
        viewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.viewModel.onNewsSuccess(response: response)
                if self?.pageNo == 1 {
                    self?.fetchVideoList()
                } else {
                    stopLoader()
                    self?.newsTableView.reloadData()
                }
            })
            .store(in: &cancellable)
    }
    
    func fetchVideoList() {
        videoViewModel.fetchVideoListAsyncCall()
        videoViewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.videoViewModel.onVideoSuccess(response: response)
                self?.viewModel.onVideoSuccess(response: response)
                self?.newsTableView.reloadData()
                stopLoader()
            })
            .store(in: &cancellable)
    }
    
}


extension NewsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.section[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.section[indexPath.section] {
        case .banner(_):
            guard let cell = newsTableView.dequeueReusableCell(
                withIdentifier: NewsBannerTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? NewsBannerTableViewCell else { return UITableViewCell() }
            
            let model = viewModel.section[indexPath.section].data
            cell.configureCell(with: NewsTableCellViewModel(model: model as! [NewsDetail]))
            return cell
            
        case .latest(_):
            guard let cell = newsTableView.dequeueReusableCell(
                withIdentifier: TrendingNewsParentTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? TrendingNewsParentTableViewCell else { return UITableViewCell() }
            
            let viewModel = viewModel.section[indexPath.section].data
            cell.configureCell(with: TrendingCollectionCellViewModel(model: viewModel as! [NewsDetail]))
            return cell
            
        case .trending(_):
            guard let cell = newsTableView.dequeueReusableCell(
                withIdentifier: LatestNewsTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? LatestNewsTableViewCell else { return UITableViewCell() }
            
            let viewModel = viewModel.section[indexPath.section].data
            cell.configureCell(with: TrendingNewsCellViewModel(model: viewModel[indexPath.row] as! NewsDetail))
            return cell
            
        case .video(_):
            guard let cell = newsTableView.dequeueReusableCell(
                withIdentifier: NewsVideoTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? NewsVideoTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(with: videoViewModel.model)
            cell.playButtonAction = { avPlayerVC in
                avPlayerVC.player?.play()
                self.present(avPlayerVC, animated: true)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.section[section] {
        case .latest(_), .video(_), .trending(_):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsHeaderTableViewCell.reuseIdentifier
            ) as? NewsHeaderTableViewCell else { return nil }
            
            cell.configureCell(with: viewModel.section[section].title)
            return cell.contentView
            
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch viewModel.section[indexPath.section] {
        case .trending(_):
            let model = viewModel.section[indexPath.section].data[indexPath.row]
            NotificationCenter.default.post(name: .moveToNewsDetail, object: nil, userInfo: ["NewsDetails": model])
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.section[indexPath.section].rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.section[section].headerHeight
    }
    
}

extension NewsVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == newsTableView {
            if (scrollView.contentOffset.y + scrollView.frame.height) >= scrollView.contentSize.height {
                if let lastPage = viewModel.model.lastPage, let currentPage = viewModel.model.currentPage, currentPage < lastPage {
                    startLoader()
                    self.pageNo = currentPage + 1
                    viewModel.fetchNewsDataAsyncCall(page: self.pageNo, keyword: "/\(viewModel.sportType.rawValue)")
                }
            }
        }
        
    }
    
}
