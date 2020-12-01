//
//  SearchViewController.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 19/11/2020.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private var searchViewModel: SearchViewModel!
    
    let schedulerProvider:SchedulerProvider = SchedulerProvider()
    let tvShowsRepository: TvShowsRepository = TvShowsRepositoryImpl(tvShowsApi: TvShowsApi.shared)
    let genresRepository: GenresRepository = InMemoryGenresRepositoryImpl(genresApi: GenresApi.shared)
    
    let searchController = UISearchController()
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)

        setupSearchController()
        setupItemsTableView()
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func addObservers() {
        searchViewModel = SearchViewModel(
            schedulerProvider: schedulerProvider,
            tvShowsRepository: tvShowsRepository,
            genresRepository: genresRepository)
        
        searchController.searchBar.rx.text
            .orEmpty
            .throttle(1, scheduler: schedulerProvider.ui().self)
            .subscribe(onNext: {[weak self] query in
                self?.searchViewModel.searchTvShows(query: query)
            }).disposed(by: disposeBag)
        
        searchViewModel.tvShows
            .asObservable()
            .bind(to: itemsTableView.rx.items(cellIdentifier: "item_cell", cellType: ItemViewCell.self)) {[weak self] row, element, cell in
                if
                    let weakSelf = self,
                    let viewModel = weakSelf.searchViewModel.viewModelForTvShow(at: row) {
                    
                    cell.configurate(whit: viewModel)
                    cell.continueButton.rx.tap.asDriver().drive(onNext: { _ in
                        cell.continueButton.isSelected = !viewModel.isSubscribed
                        weakSelf.searchViewModel.subscribeOrUnsubscribe(at: row)
                    }).disposed(by: weakSelf.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        itemsTableView.rx.itemSelected.asDriver()
            .asDriver()
            .drive(onNext: {[weak self] indexPath in
                guard let id = self?.searchViewModel.getId(by: indexPath.row) else { return }
                self?.navigateToDetailView(tvShowId: id)
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupItemsTableView() {
        itemsTableView.register(UINib(nibName: "\(ItemViewCell.self)", bundle: nil), forCellReuseIdentifier: "item_cell")
        itemsTableView.backgroundColor = nil
        itemsTableView.backgroundView = nil
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search your Tv Show"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.becomeFirstResponder()
        
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
}
