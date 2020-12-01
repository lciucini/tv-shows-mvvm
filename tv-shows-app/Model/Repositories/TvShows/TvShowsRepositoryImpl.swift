//
//  TvShowsLocalRepository.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import Foundation
import RxSwift

class TvShowsRepositoryImpl: TvShowsRepository {
    private let tvShowsApi: TvShowsApi
    
    init(tvShowsApi: TvShowsApi) {
        self.tvShowsApi = tvShowsApi
    }
    
    func fetch() -> Single<PagedResults<TvShow>> {
        return tvShowsApi.fetchPopularTvShows(params: nil)
    }
    
    func search(query: String, page: Int) -> Single<PagedResults<TvShow>> {
        return tvShowsApi.search(params: [ "query": query ,"page": "\(page)" ])
    }
    
    func getDetails(id: Int64) -> Single<TvShow> {
        return tvShowsApi.getDetail(id: id, params: nil)
    }
    
    func unSubscribe(to tvShow: TvShow) -> Completable {
        return Completable.create { completable in
            do {
                try AppDatabase.shared.deleteTvShow(ids: [tvShow.id])
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }
    
    func subscribe(to tvShow: TvShow) -> Completable {
        return Completable.create { completable in
            do {
                var tvShowToSave = tvShow
                try AppDatabase.shared.saveTvShow(&tvShowToSave)
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }
    
    func fetchSubscribedTvShows() -> Single<[TvShow]> {
        return Single.create { single in
            do {
                let result = try AppDatabase.shared.getAllTvShows()
                single(.success(result))
            } catch let error {
                single(.error(error))
            }
            return Disposables.create {}
        }
    }
    
    func getSubscribedTvShow(by id: Int64) -> Single<TvShow?> {
        return Single.create { single in
            do {
                let result = try AppDatabase.shared.getTvShow(by: id)
                single(.success(result))
            } catch let error {
                single(.error(error))
            }
            return Disposables.create {}
        }
    }
}
