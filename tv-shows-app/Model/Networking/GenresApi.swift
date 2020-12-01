//
//  GenresApi.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import Foundation
import RxSwift

class GenresApi: NetworkManager {
    public static let shared = GenresApi()
    public override init() {}
    
    func fetch(params: [String: String]? = nil) -> Single<GenreList> {
        return fetch(url: "/genre/tv/list", params: params)
    }
}
