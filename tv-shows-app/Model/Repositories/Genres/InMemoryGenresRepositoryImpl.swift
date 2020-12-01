//
//  InMemoryGenresRepository.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import RxSwift

class InMemoryGenresRepositoryImpl: GenresRepository {
    private static var genres: [Genre] = []
    private let genresApi: GenresApi
    private let disposeBag = DisposeBag()
    
    init(genresApi: GenresApi) {
        self.genresApi = genresApi
    }
    
    func fetch() -> Single<GenreList> {
        return genresApi.fetch(params: nil)
            .do(onSuccess: { response in
                InMemoryGenresRepositoryImpl.genres = response.genres
            })
    }
    
    func getGenreName(by id: Int) -> String? {
        return InMemoryGenresRepositoryImpl.genres.first(where: { $0.id == id })?.name
    }
}
