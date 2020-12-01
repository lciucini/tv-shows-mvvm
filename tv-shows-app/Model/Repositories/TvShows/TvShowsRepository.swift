//
//  TvShowsRepository.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import RxSwift

protocol TvShowsRepository: class {
    func fetch() -> Single<PagedResults<TvShow>>
    func search(query: String, page: Int) -> Single<PagedResults<TvShow>>
    func getDetails(id: Int64) -> Single<TvShow>
    func subscribe(to tvShow: TvShow) -> Completable
    func unSubscribe(to tvShow: TvShow) -> Completable
    func fetchSubscribedTvShows() -> Single<[TvShow]>
    func getSubscribedTvShow(by id: Int64) -> Single<TvShow?>
}
