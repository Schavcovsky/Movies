//
//  MovieCategory.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

enum MovieCategory: String {
    case search = "search/movie"
    case topRated = "movie/top_rated"
    case nowPlaying = "movie/now_playing"
    case popular = "movie/popular"
    case upcoming = "movie/upcoming"

    // User-friendly display name
    var displayName: String {
        switch self {
            case .search: return "Search"
            case .topRated: return "Top Rated"
            case .nowPlaying: return "Now Playing"
            case .popular: return "Popular"
            case .upcoming: return "Upcoming"
        }
    }
}
