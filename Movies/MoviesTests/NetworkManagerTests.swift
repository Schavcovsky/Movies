//
//  NetworkManagerTests.swift
//  MoviesTests
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import XCTest
@testable import Movies

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager()
    }

    func testFetchNowPlayingMoviesSuccess() {
        let expectedData = Data("""
        {
            "page": 1,
            "results": [
                //... A subset of your JSON data ...
            ],
            "total_pages": 10,
            "total_results": 200
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "NowPlayingMoviesFetch")

        networkManager.fetchMovies(forCategory: MovieCategoryNowPlaying, query: nil, page: 1) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchMovieDetailsSuccess() {
        let expectedData = Data("""
        {
          "adult": false,
          "backdrop_path": "/mjCTpAo0GIfK8tzt1YPJuy1dA9S.jpg",
          "belongs_to_collection": null,
          "budget": 2700000,
          "genres": [
            {
              "id": 35,
              "name": "Comedy"
            },
            {
              "id": 18,
              "name": "Drama"
            }
          ],
          "homepage": "http://www.sommersturm.de/main.html",
          "id": 342,
          "imdb_id": "tt0420206",
          "original_language": "de",
          "original_title": "Sommersturm",
          "overview": "Tobi and Achim, the pride of the local crew club, have been the best of friends for years and are convinced that nothing will ever stand in the way of their friendship. They look forward to the upcoming summer camp and the crew competition. Then the gay team from Berlin arrives and Tobi is totally confused. The evening before the races begin, the storm that breaks out is more than meteorlogical...",
          "popularity": 7.367,
          "poster_path": "/7fqQmDzKGIiIk0mORANha9SsLVy.jpg",
          "production_companies": [
            {
              "id": 161,
              "logo_path": null,
              "name": "Claussen+Wöbke Filmproduktion",
              "origin_country": "DE"
            }
          ],
          "production_countries": [
            {
              "iso_3166_1": "DE",
              "name": "Germany"
            }
          ],
          "release_date": "2004-09-02",
          "revenue": 2085166,
          "runtime": 98,
          "spoken_languages": [
            {
              "english_name": "German",
              "iso_639_1": "de",
              "name": "Deutsch"
            }
          ],
          "status": "Released",
          "tagline": "",
          "title": "Summer Storm",
          "video": false,
          "vote_average": 6.694,
          "vote_count": 183
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "MovieDetailsFetch")

        let movieId = 342 // Example movie ID
        networkManager.fetchMovieDetails(forId: movieId) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchPopularMoviesSuccess() {
        let expectedData = Data("""
        {
            "page": 1,
            "results": [/*... A subset of your JSON data for popular movies ...*/],
            "total_pages": 41501,
            "total_results": 830019
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "PopularMoviesFetch")

        networkManager.fetchMovies(forCategory: MovieCategoryPopular, query: nil, page: 1) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchTopRatedMoviesSuccess() {
        let expectedData = Data("""
        {
            "page": 1,
            "results": [/*... A subset of your JSON data for top rated movies ...*/],
            "total_pages": 449,
            "total_results": 8971
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "TopRatedMoviesFetch")

        networkManager.fetchMovies(forCategory: MovieCategoryTopRated, query: nil, page: 1) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchUpcomingMoviesSuccess() {
        let expectedData = Data("""
        {
            "dates": {
                "maximum": "2023-12-20",
                "minimum": "2023-11-29"
            },
            "page": 1,
            "results": [/*... A subset of your JSON data for upcoming movies ...*/],
            "total_pages": 29,
            "total_results": 567
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "UpcomingMoviesFetch")

        networkManager.fetchMovies(forCategory: MovieCategoryUpcoming, query: nil, page: 1) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchMovieRatingsSuccess() {
        let expectedData = Data("""
        {
            "page": 1,
            "results": [
                //... A subset of your JSON data ...
            ],
            "total_pages": 5,
            "total_results": 20
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "MovieRatingsFetch")

        let movieId = 123 // Example movie ID
        networkManager.fetchMovieRatings(forId: movieId, page: 1) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchMoviesSearchSuccess() {
        let expectedData = Data("""
        {
            "page": 1,
            "results": [
                //... A subset of your JSON data for movie search results ...
            ],
            "total_pages": 3,
            "total_results": 15
        }
        """.utf8)
        mockSession.mockData = expectedData

        let expectation = self.expectation(description: "MoviesSearchFetch")

        let query = "action" // Example search query
        networkManager.fetchMovies(forCategory: MovieSearch, query: query, page: 1) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            // Additional data parsing and validation tests here
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
}
