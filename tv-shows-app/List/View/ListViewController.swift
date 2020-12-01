//
//  ListViewController.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import UIKit
import Kingfisher
import PureLayout
import RxSwift
import RxCocoa

class ListViewController: BaseViewController {
    var disposeBag = DisposeBag()
    var listViewModel: ListViewModel!
    
    let searchController = UISearchController(searchResultsController: nil)
    let schedulerProvider:SchedulerProvider = SchedulerProvider()
    let tvShowsRepository: TvShowsRepository = TvShowsRepositoryImpl(tvShowsApi: TvShowsApi.shared)
    let genresRepository: GenresRepository = InMemoryGenresRepositoryImpl(genresApi: GenresApi.shared)
    
    @IBOutlet weak var tvShowsTopLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var subscriptionCollectionView: UICollectionView! {
        didSet {
            subscriptionCollectionView.backgroundView = nil
            subscriptionCollectionView.backgroundColor = .none
            subscriptionCollectionView.delegate = self
        }
    }
    
    @IBOutlet weak var tvShowsCollectionView: UICollectionView! {
        didSet {
            tvShowsCollectionView.backgroundView = nil
            tvShowsCollectionView.backgroundColor = .none
            tvShowsCollectionView.delegate = self
        }
    }
    
    @IBOutlet weak var subscriptionLabel: UILabel! {
        didSet {
            subscriptionLabel.body(.xs, .text_light, .medium)
        }
    }
    
    @IBOutlet weak var moviesLabel: UILabel!{
        didSet {
            moviesLabel.body(.xs, .text_light, .medium)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listViewModel.fetchTvShows()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addObservers()
        setupNavigationBarItems()
        setupMoviesTableView()
    }
    
    private func addObservers() {
        listViewModel = ListViewModel(
            schedulerProvider: schedulerProvider,
            tvShowsRepository: tvShowsRepository,
            genresRepository: genresRepository)
        
        listViewModel?.subscriptedTvShows
            .drive(onNext: {[weak self] values in
                self?.subscriptionLabel.isHidden = values.isEmpty
                self?.subscriptionCollectionView.isHidden = values.isEmpty
                
                if !values.isEmpty {
                    self?.tvShowsTopLabelConstraint.autoRemove()
                    return
                }
                
                self?.tvShowsTopLabelConstraint.autoInstall()
            }).disposed(by: disposeBag)
        
        listViewModel?
            .isFetching
            .drive(activityLoadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // MARK: Bind Collection views
        listViewModel?.tvShows
            .asObservable()
            .bind(to: tvShowsCollectionView.rx.items(cellIdentifier: "movie_cell_view", cellType: TvShowViewCell.self)) { [weak self] _, tvShow, cell in
                guard let genresRepository = self?.genresRepository else { return }
                
                cell.configurate(viewModel: TvShowViewModel(tvShow: tvShow, genresRepository: genresRepository))
            }
            .disposed(by: disposeBag)
        
        listViewModel?.subscriptedTvShows
            .asObservable()
            .bind(to: subscriptionCollectionView.rx.items(cellIdentifier: "subscription_cell", cellType: SubscriptionViewCell.self)) { [weak self] _, tvShow, cell in
                guard let genresRepository = self?.genresRepository else { return }
                
                let viewModel = TvShowViewModel(tvShow: tvShow, genresRepository: genresRepository)
                
                cell.imageURL = viewModel.posterURL
            }
            .disposed(by: disposeBag)
        
        // MARK: Add selection observers
        tvShowsCollectionView.rx.itemSelected.asDriver()
            .asDriver()
            .drive(onNext: {[weak self] indexPath in
                guard let id = self?.listViewModel.getId(by: indexPath.row) else { return }
                self?.navigateToDetailView(tvShowId: id)
            }).disposed(by: disposeBag)
        
        subscriptionCollectionView.rx.itemSelected.asDriver()
            .asDriver()
            .drive(onNext: {[weak self] indexPath in
                guard let id = self?.listViewModel.getSubscribedTvShowId(by: indexPath.row) else { return }
                self?.navigateToDetailView(tvShowId: id)
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBarItems() {
        navigationItem.title = "TV Show Reminder"
        
        setupLeftNavigationBar()
    }
    
    private func setupLeftNavigationBar() {
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(named: "search_icon"), for: .normal)
        searchButton.tintColor = .light
        
        searchButton.rx.tap.subscribe(onNext: {
            self.navigateToSearch()
        }).disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    private func setupMoviesTableView() {
        tvShowsCollectionView.register(UINib(nibName: "\(TvShowViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "movie_cell_view")
        subscriptionCollectionView.register(SubscriptionViewCell.self, forCellWithReuseIdentifier: "subscription_cell")
    }
    
    private func navigateToSearch() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == subscriptionCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: 150)
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 156)
    }
}
