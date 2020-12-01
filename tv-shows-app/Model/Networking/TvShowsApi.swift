//
//  TvShowsApi.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import Foundation
import RxSwift

class TvShowsApi: NetworkManager {
    public static let shared = TvShowsApi()
    private override init() {}
    
    func fetchPopularTvShows(params: [String: String]? = nil) -> Single<TvShowsResponse> {
        return fetch(url: "/tv/popular", params: params)
    }
    
    func search(params: [String : String]?) -> Single<TvShowsResponse> {
        return fetch(url: "/search/tv", params: params)
    }
    
    func getDetail(id: Int64, params: [String : String]?) -> Single<TvShow> {
        return fetch(url: "/tv/\(id)", params: params)
    }
}
