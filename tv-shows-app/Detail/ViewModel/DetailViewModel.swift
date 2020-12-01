//
//  DetailViewModel.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 23/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailViewModel {
    typealias OptionalTvShow = TvShow?
    typealias OptionalId = Int64?
    
    private let disposeBag = DisposeBag()
    private let schedulerProvider: SchedulerProvider
    private let tvShowsRepository: TvShowsRepository
    private let genresRepository: GenresRepository
    
    init(tvShowId: Int64, schedulerProvider: SchedulerProvider, tvShowsRepository: TvShowsRepository, genresRepository: GenresRepository) {
        self.schedulerProvider = schedulerProvider
        self.tvShowsRepository = tvShowsRepository
        self.genresRepository = genresRepository
        
        checkSubscribed(by: tvShowId)
        getDetails(by: tvShowId)
    }
    
    private let _tvShowDetails = BehaviorRelay<OptionalTvShow>(value: nil)
    private let _error = BehaviorRelay<String>(value: "")
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _isSubscribing = BehaviorRelay<Bool>(value: false)
    private let _isSubscribe = BehaviorRelay<Bool>(value: false)
            
    var tvShowDetails: Driver<OptionalTvShow> {
        return _tvShowDetails.asDriver()
    }
    
    var error: Driver<String> {
        return _error.asDriver()
    }
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var isSubscribing: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var isSubscribe: Driver<Bool> {
        return _isSubscribe.asDriver()
    }
    
    func getTvShowViewModel(by tvShow: TvShow) -> TvShowViewModel? {        
        return TvShowViewModel(tvShow: tvShow, genresRepository: genresRepository)
    }
    
    func subscribeOrUnsubscribe() {
        if _isSubscribe.value {
            unSubscrive()
            return
        }
        
        subscribe()
    }
    
    private func subscribe() {
        guard let tvShowDetails = _tvShowDetails.value else { return }
        
        tvShowsRepository.subscribe(to: tvShowDetails)
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .do(onSubscribe: { self._isSubscribing.accept(true) })
            .subscribe(onCompleted: {
                self._isSubscribing.accept(true)
                self._isSubscribe.accept(true)
            }, onError: { errpr in
                self._error.accept("Ocurrio un error")
            }).disposed(by: disposeBag)
    }
    
    private func unSubscrive() {
        guard let tvShowDetails = _tvShowDetails.value else { return }
        
        tvShowsRepository.unSubscribe(to: tvShowDetails)
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .do(onSubscribe: { self._isSubscribing.accept(true) })
            .subscribe(onCompleted: {
                self._isSubscribing.accept(true)
                self._isSubscribe.accept(false)
            }, onError: { errpr in
                self._error.accept("Ocurrio un error")
            }).disposed(by: disposeBag)
    }
    
    private func checkSubscribed(by id: Int64) {
        tvShowsRepository.getSubscribedTvShow(by: id)
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .do(onSuccess: { _ in self._isFetching.accept(false) },  onSubscribe: { self._isFetching.accept(true) })
            .subscribe(onSuccess: { response  in
                self._isSubscribe.accept(response?.id == id)
            }, onError: { _ in }).disposed(by: disposeBag)
    }
    
    private func getDetails(by id: Int64) {
        tvShowsRepository.getDetails(id: id)
            .subscribeOn(schedulerProvider.io())
            .observeOn(schedulerProvider.ui())
            .do(onSuccess: { _ in self._isFetching.accept(false) },  onSubscribe: { self._isFetching.accept(true) })
            .subscribe(onSuccess: { response  in
                self._tvShowDetails.accept(response)
            }, onError: { error in
                self._error.accept("No se encontraron resultados")
            }).disposed(by: disposeBag)
    }
}
