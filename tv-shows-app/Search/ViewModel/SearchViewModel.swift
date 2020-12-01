//
//  SearchViewModel.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 23/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchViewModel {
    typealias TvShows = [TvShow]
    
    private let disposeBag = DisposeBag()
    private let schedulerProvider: SchedulerProvider
    private let tvShowsRepository: TvShowsRepository
    private let genresRepository: GenresRepository
    
    init(schedulerProvider: SchedulerProvider, tvShowsRepository: TvShowsRepository, genresRepository: GenresRepository) {
        self.schedulerProvider = schedulerProvider
        self.tvShowsRepository = tvShowsRepository
        self.genresRepository = genresRepository
    }
    
    private let _tvShows = BehaviorRelay<TvShows>(value: [])
    private let _error = BehaviorRelay<String>(value: "")
    private let _numberOfTvShows = BehaviorRelay<Int>(value: 0)
            
    var tvShows: Driver<TvShows> {
        return _tvShows.asDriver()
    }
    
    var error: Driver<String> {
        return _error.asDriver()
    }
    
    var numberOfTvShows: Int {
        return _numberOfTvShows.value
    }
    
    func viewModelForTvShow(at index: Int) -> TvShowViewModel? {
        guard index < _numberOfTvShows.value else {
            return nil
        }
        
        return TvShowViewModel(tvShow: _tvShows.value[index], genresRepository: genresRepository)
    }
    
    func subscribeOrUnsubscribe(at index: Int) {
        if let subscribe = _tvShows.value[index].subscribed, subscribe {
            unSubscrive(at: index)
            return
        }
        
        subscribe(at: index)
    }
    
    private func subscribe(at index: Int) {
        let tvShow = _tvShows.value[index]
                
        tvShowsRepository.subscribe(to: tvShow)
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func unSubscrive(at index: Int) {
        let tvShow = _tvShows.value[index]
                
        tvShowsRepository.unSubscribe(to: tvShow)
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func getId(by index: Int) -> Int64? {
        return _tvShows.value[index].id
    }
    
    func searchTvShows(query: String) {
        Single.zip(tvShowsRepository.search(query: query, page: 1), tvShowsRepository.fetchSubscribedTvShows())
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .subscribe(onSuccess: { resTvShows, resSubscribedTvShows  in
                self._numberOfTvShows.accept(resTvShows.results.count)
                
                self._tvShows.accept(resTvShows.results.map { tvShow in
                    var newTvShow = tvShow
                    let contain = resSubscribedTvShows.contains(where: { $0.id == tvShow.id })
                    newTvShow.subscribed = contain
                    return newTvShow
                })
            }).disposed(by: disposeBag)
    }
}
