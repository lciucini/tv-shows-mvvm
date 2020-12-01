//
//  ListViewModel.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 20/11/2020.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

struct ListViewModel {
    typealias TvShows = [TvShow]
    typealias TvShowsSubscribed = [TvShow]
    
    private let disposeBag = DisposeBag()
    private let schedulerProvider: SchedulerProvider
    private let tvShowsRepository: TvShowsRepository
    private let genresRepository: GenresRepository
    
    init(schedulerProvider: SchedulerProvider, tvShowsRepository: TvShowsRepository, genresRepository: GenresRepository) {
        self.schedulerProvider = schedulerProvider
        self.tvShowsRepository = tvShowsRepository
        self.genresRepository = genresRepository
        
        fetchTvShows()
    }
    
    private let _tvShows = BehaviorRelay<TvShows>(value: [])
    private let _subscriptedTvShows = BehaviorRelay<TvShowsSubscribed>(value: [])
    private let _numberOfTvShows = BehaviorRelay<Int>(value: 0)
    private let _numberOfTvShowsSubscripted = BehaviorRelay<Int>(value: 0)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var subscriptedTvShows: Driver<TvShowsSubscribed> {
        return _subscriptedTvShows.asDriver()
    }
    
    var tvShows: Driver<TvShows> {
        return _tvShows.asDriver()
    }
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfTvShows: Int {
        return _numberOfTvShows.value
    }
    
    var numberOfTvShowsSubscripted: Int {
        return _numberOfTvShowsSubscripted.value
    }
    
    func getId(by index: Int) -> Int64? {
        return _tvShows.value[index].id
    }
    
    func getSubscribedTvShowId(by index: Int) -> Int64? {
        return _subscriptedTvShows.value[index].id
    }
    
    func viewModelForTvShow(at index: Int) -> TvShowViewModel? {
        guard index < _numberOfTvShows.value else {
            return nil
        }
        
        return TvShowViewModel(tvShow: _tvShows.value[index], genresRepository: genresRepository)
    }
    
    func viewModelForSubscribedTvShow(at index: Int) -> TvShowViewModel? {
        guard index < _numberOfTvShowsSubscripted.value else {
            return nil
        }
        
        return TvShowViewModel(tvShow: _tvShows.value[index], genresRepository: genresRepository)
    }
    
    func fetchTvShows() {
        self._tvShows.accept([])
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        Single.zip(genresRepository.fetch(), tvShowsRepository.fetch(), tvShowsRepository.fetchSubscribedTvShows())
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .do(onSubscribe: { self._isFetching.accept(true) })
            .subscribe(onSuccess: { (_, resTvShows, resTvShowsSubscribed)  in
                var urls: [URL] = []
                
                // Backdrop Images
                urls.append(contentsOf: resTvShows.results.map { $0.backdropURL })
                urls.append(contentsOf: resTvShowsSubscribed.map { $0.backdropURL } )
                
                // BackDrop Poster
                urls.append(contentsOf: resTvShows.results.map { $0.posterURL })
                urls.append(contentsOf: resTvShowsSubscribed.map { $0.posterURL } )
                
                preloadImages(urls: urls) {
                    self._numberOfTvShows.accept(resTvShows.results.count)
                    self._tvShows.accept(resTvShows.results)
                    
                    self._subscriptedTvShows.accept(resTvShowsSubscribed)
                    self._numberOfTvShowsSubscripted.accept(resTvShowsSubscribed.count)
                    self._isFetching.accept(false)
                }
            }, onError: { error in
                self._error.accept("No se encontraron resultados")
            }).disposed(by: disposeBag)
    }
    
    private func preloadImages(urls: [URL], completionBlock: @escaping() -> Void) {
        let prefetcher = ImagePrefetcher(urls: urls, completionHandler:  {
            skippedResources, failedResources, completedResources in
            completionBlock()
        })
        
        prefetcher.start()
    }
}
