//
//  GenresRepository.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import RxSwift

protocol GenresRepository: class {
    func fetch() -> Single<GenreList>
    func getGenreName(by id: Int) -> String?
}
