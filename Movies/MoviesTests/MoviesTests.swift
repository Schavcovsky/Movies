//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Alejandro Villalobos on 23-11-23.
//

import XCTest
@testable import Movies

final class MoviesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDecodingMovie() throws {
            let json = """
            {
                "dates": {
                    "maximum": "2023-12-31",
                    "minimum": "2023-01-01"
                },
                "id": 123,
                "page": 1,
                "results": [],
                "total_pages": 5,
                "total_results": 50
            }
            """.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            let movie = try decoder.decode(Movie.self, from: json)
            
            XCTAssertEqual(movie.id, 123)
            XCTAssertEqual(movie.page, 1)
            XCTAssertEqual(movie.results?.count, 0)
            XCTAssertEqual(movie.totalPages, 5)
            XCTAssertEqual(movie.totalResults, 50)
            XCTAssertEqual(movie.dates?.minimum, "2023-01-01")
            XCTAssertEqual(movie.dates?.maximum, "2023-12-31")
        }

    func testDecodingResult() throws {
            let json = """
            {
                "author": "Juanito Perez",
                "author_details": {
                    "name": "Juanito",
                    "username": "johndoe",
                    "avatar_path": "/avatar.png",
                    "rating": 4
                },
                "adult": false,
                "backdrop_path": "/backdrop.jpg",
                "content": "Great movie!",
                "created_at": "2023-11-26T19:00:00Z",
                "genres": [],
                "genre_ids": [],
                "id": 456,
                "original_language": "en",
                "original_title": "The Movie",
                "overview": "A fantastic movie",
                "popularity": 8.9,
                "poster_path": "/poster.jpg",
                "release_date": "2023-01-01",
                "title": "The Movie",
                "updated_at": "2023-11-26T19:00:00Z",
                "url": "https://example.com",
                "video": true,
                "vote_average": 8.0,
                "vote_count": 100
            }
            """.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(Result.self, from: json)
            
            XCTAssertEqual(result.id, 456)
            XCTAssertEqual(result.author, "Juanito Perez")
            XCTAssertEqual(result.authorDetails?.name, "Juanito")
            XCTAssertEqual(result.adult, false)
            XCTAssertEqual(result.backdropPath, "/backdrop.jpg")
            XCTAssertEqual(result.content, "Great movie!")
            XCTAssertEqual(result.createdAt, "2023-11-26T19:00:00Z")
            XCTAssertEqual(result.genres?.count, 0)
            XCTAssertEqual(result.genreIDS?.count, 0)
            XCTAssertEqual(result.originalLanguage, "en")
            XCTAssertEqual(result.originalTitle, "The Movie")
            XCTAssertEqual(result.overview, "A fantastic movie")
            XCTAssertEqual(result.popularity, 8.9)
            XCTAssertEqual(result.posterPath, "/poster.jpg")
            XCTAssertEqual(result.releaseDate, "2023-01-01")
            XCTAssertEqual(result.title, "The Movie")
            XCTAssertEqual(result.updatedAt, "2023-11-26T19:00:00Z")
            XCTAssertEqual(result.url, "https://example.com")
            XCTAssertEqual(result.video, true)
            XCTAssertEqual(result.voteAverage, 8.0)
            XCTAssertEqual(result.voteCount, 100)
        }
}
