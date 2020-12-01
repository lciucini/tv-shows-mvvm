//
//  GenresRepository.swift
//  tv-shows-appTests
//
//  Created by Lucas Ciucini on 24/11/2020.
//

import Foundation
import RxSwift
@testable import tv_shows_app

class GenresRepositoryMock: GenresRepository {
    private static var genres: [Genre] = [
        Genre(id: 1, name: "Genre 1"),
        Genre(id: 1, name: "Genre 2")
    ]
    
    func fetch() -> Single<GenreList> {
        return Single.create { single in
            let res = GenreList(genres: GenresRepositoryMock.genres)
            single(.success(res))
            
            return Disposables.create()
        }
    }
    
    func getGenreName(by id: Int) -> String? {
        return GenresRepositoryMock.genres.first(where: { $0.id == id })?.name
    }
}
