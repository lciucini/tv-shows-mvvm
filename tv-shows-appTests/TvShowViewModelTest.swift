//
//  TvShowViewModelTest.swift
//  tv-shows-appTests
//
//  Created by Lucas Ciucini on 24/11/2020.
//

import XCTest
@testable import tv_shows_app

class TvShowViewModelTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let tvShow = TvShow(
            originalName: "Test Tv Show Original",
            genreIds: [1, 2],
            genres: [Genre(id: 1, name: "Genre 1"), Genre(id: 2, name: "Genre 2")],
            name: "Test Tv",
            popularity: 2.5,
            originCountry: ["AR"],
            voteCount: 10,
            firstAirDate: Date(julianDay: 1),
            backdropPath: "123.jpg",
            originalLanguage: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
            id: 1,
            voteAverage: 5,
            overview: "Teasdasda asodiajsoidja sdaoisdjaiosd",
            posterPath: "1234",
            subscribed: nil)
        
        let genreRepository = GenresRepositoryMock()
        
        let tvShowViewModel = TvShowViewModel(tvShow: tvShow, genresRepository: genreRepository)
        
        XCTAssertEqual(tvShowViewModel.backdropURL , tvShow.backdropURL)
        XCTAssertEqual(tvShowViewModel.posterURL , tvShow.posterURL)
        XCTAssertEqual(tvShowViewModel.genre, "Genre 1")
        XCTAssertEqual(tvShowViewModel.firstAirYear, "4714")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
