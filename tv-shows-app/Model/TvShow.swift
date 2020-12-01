//
//  TvShow.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 20/11/2020.
//

import Foundation
import GRDB

typealias TvShowsResponse = PagedResults<TvShow>

struct TvShow: Codable {        
    let originalName: String
    let genreIds: [Int]?
    let genres: [Genre]?
    let name: String
    let popularity: Double
    let originCountry: [String]
    let voteCount: Int
    let firstAirDate: Date?
    let backdropPath: String?
    let originalLanguage: String
    var id: Int64
    let voteAverage: Double
    let overview: String
    let posterPath: String?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath ?? "")")!
    }
    
    var subscribed: Bool?
}

// MARK: - Persistence
extension TvShow: FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let originalName = Column(CodingKeys.originalName)
        static let genreIds = Column(CodingKeys.genreIds)
        static let name = Column(CodingKeys.name)
        static let popularity = Column(CodingKeys.popularity)
        static let originCountry = Column(CodingKeys.originCountry)
        static let voteCount = Column(CodingKeys.voteCount)
        static let firstAirDate = Column(CodingKeys.firstAirDate)
        static let backdropPath = Column(CodingKeys.backdropPath)
        static let originalLanguage = Column(CodingKeys.originalLanguage)
        static var id = Column(CodingKeys.id)
        static let voteAverage = Column(CodingKeys.voteAverage)
        static let overview = Column(CodingKeys.overview)
        static let posterPath = Column(CodingKeys.posterPath)
        static let subscribed = Column(CodingKeys.subscribed)
    }
    
    /// Updates a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
