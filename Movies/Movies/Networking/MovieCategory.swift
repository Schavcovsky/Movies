//
//  MovieCategory.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

enum MovieCategory: String {
    case search = "search/movie"
    case nowPlaying = "movie/now_playing"
    case popular = "movie/popular"
    case topRated = "movie/top_rated"
    case upcoming = "movie/upcoming"

    // User-friendly display name
    var displayName: String {
        switch self {
            case .search: return "Search"
            case .nowPlaying: return "Now Playing"
            case .popular: return "Popular"
            case .topRated: return "Top Rated"
            case .upcoming: return "Upcoming"
        }
    }
}
