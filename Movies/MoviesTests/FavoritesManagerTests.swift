//
//  FavoritesManagerTests.swift
//  MoviesTests
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import XCTest
@testable import Movies

class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    
    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager.shared
        favoritesManager.clearFavorites() // Ensuring a clean state before each test
    }
    
    override func tearDown() {
        favoritesManager.clearFavorites() // Cleaning up after each test
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty)
    }
    
    func testAddSingleFavorite() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        XCTAssertTrue(favoritesManager.isFavorite(movieId: 1))
    }
    
    func testRemoveSingleFavorite() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        XCTAssertFalse(favoritesManager.isFavorite(movieId: 1))
    }
    
    func testToggleFavoriteMultipleTimes() {
        let movieId = 1
        let movieName = "Movie 1"
        
        for _ in 1...3 {
            favoritesManager.toggleFavorite(movieId: movieId, movieName: movieName)
        }
        
        XCTAssertTrue(favoritesManager.isFavorite(movieId: movieId))
    }
    
    func testAddMultipleFavorites() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        favoritesManager.toggleFavorite(movieId: 2, movieName: "Movie 2")
        
        let favorites = favoritesManager.getFavorites()
        XCTAssertEqual(favorites.count, 2)
        XCTAssertEqual(favorites[1], "Movie 1")
        XCTAssertEqual(favorites[2], "Movie 2")
    }
    
    func testGetEmptyFavorites() {
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty)
    }
    
    func testGetNonEmptyFavorites() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        XCTAssertFalse(favoritesManager.getFavorites().isEmpty)
    }
    
    func testGetFavoritesAfterRemovingSome() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        favoritesManager.toggleFavorite(movieId: 2, movieName: "Movie 2")
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1") // Remove movie 1
        
        let favorites = favoritesManager.getFavorites()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertNil(favorites[1])
        XCTAssertEqual(favorites[2], "Movie 2")
    }
    
    func testSortingWithMultipleFavorites() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        sleep(1) // Ensure there is a time difference
        favoritesManager.toggleFavorite(movieId: 2, movieName: "Movie 2")
        
        let sortedFavorites = favoritesManager.getFavoritesSortedByMostRecent()
        XCTAssertEqual(sortedFavorites.first?.id, 2)
        XCTAssertEqual(sortedFavorites.last?.id, 1)
    }
    
    func testSortingAfterRemovingAFavorite() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        sleep(1) // Ensure there is a time difference
        favoritesManager.toggleFavorite(movieId: 2, movieName: "Movie 2")
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1") // Remove movie 1
        
        let sortedFavorites = favoritesManager.getFavoritesSortedByMostRecent()
        XCTAssertEqual(sortedFavorites.count, 1)
        XCTAssertEqual(sortedFavorites.first?.id, 2)
    }
    
    func testIsFavoriteForNonexistentMovie() {
        XCTAssertFalse(favoritesManager.isFavorite(movieId: 99))
    }
    
    func testIsFavoriteAfterAdding() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        XCTAssertTrue(favoritesManager.isFavorite(movieId: 1))
    }
    
    func testIsFavoriteAfterRemoving() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        XCTAssertFalse(favoritesManager.isFavorite(movieId: 1))
    }
    
    func testClearEmptyFavorites() {
        favoritesManager.clearFavorites()
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty)
    }
    
    func testClearNonEmptyFavorites() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        favoritesManager.clearFavorites()
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty)
    }
    
    func testSortingWithNoFavorites() {
        XCTAssertTrue(favoritesManager.getFavoritesSortedByMostRecent().isEmpty)
    }
    
    func testSortingWithOneFavorite() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        let sortedFavorites = favoritesManager.getFavoritesSortedByMostRecent()
        XCTAssertEqual(sortedFavorites.count, 1)
        XCTAssertEqual(sortedFavorites.first?.id, 1)
    }
    
    func testToggleFavoriteForSameMovieIdDifferentNames() {
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1")
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1 - New Name")
        favoritesManager.toggleFavorite(movieId: 1, movieName: "Movie 1 - New Name")
        XCTAssertEqual(favoritesManager.getFavorites()[1], "Movie 1 - New Name")
    }
    
    func testAddingALargeNumberOfFavorites() {
        for i in 1...1000 {
            favoritesManager.toggleFavorite(movieId: i, movieName: "Movie \(i)")
        }
        XCTAssertEqual(favoritesManager.getFavorites().count, 1000)
    }
}
