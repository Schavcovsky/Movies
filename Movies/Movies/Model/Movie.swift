//
//  Movie.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let dates: Dates?
    let id, page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct Result: Codable {
    let author: String?
    let authorDetails: AuthorDetails?
    let adult: Bool?
    let backdropPath: String?
    let content, createdAt: String?
    let genres: [Genre]?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate, title: String?
    let updatedAt: String?
    let url: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case adult
        case backdropPath = "backdrop_path"
        case content
        case createdAt = "created_at"
        case genres
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case updatedAt = "updated_at"
        case url
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username: String?
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

////
///
///
///

// MARK: - ReviewsResponse
struct ReviewsResponse: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Review
struct Review: Codable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let createdAt: String?
    let id: String?
    let updatedAt: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}
