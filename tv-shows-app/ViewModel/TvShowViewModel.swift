//
//  TvShowViewModel.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 23/11/2020.
//

import Foundation
import RxSwift

struct TvShowViewModel {
    private let genresRepository: GenresRepository
    private var tvShow: TvShow
    
    private let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    init(tvShow: TvShow, genresRepository: GenresRepository) {
        self.tvShow = tvShow
        self.genresRepository = genresRepository
    }
    
    var name: String {
        return tvShow.name
    }
    
    var genre: String? {
        guard let genreId = tvShow.genreIds?.first else { return nil }
        return genresRepository.getGenreName(by: genreId)
    }
    
    var firstAirYear: String? {
        guard let firstAirDate = tvShow.firstAirDate else { return nil }
        return dateFormatter.string(from: firstAirDate)
    }
    
    var overview: String {
        return tvShow.overview
    }
    
    var posterURL: URL {
        return tvShow.posterURL
    }
    
    var backdropURL: URL {
        return tvShow.backdropURL
    }
    
    var isSubscribed: Bool {
        guard let subscribed = tvShow.subscribed else { return false }
        return subscribed
    }
}
