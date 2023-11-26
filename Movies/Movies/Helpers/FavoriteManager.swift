//
//  FavoriteManager.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

// Codable struct to represent a favorite movie and the date it was added
struct Favorite: Codable {
    let name: String
    let dateAdded: Date
}

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favorites"

    private var favorites: [Int: Favorite] {
        get {
            if let data = UserDefaults.standard.data(forKey: favoritesKey),
               let favorites = try? JSONDecoder().decode([Int: Favorite].self, from: data) {
                return favorites
            }
            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: favoritesKey)
            }
        }
    }
    
    private init() {}
    
    func getFavorites() -> [Int: String] {
        return favorites.mapValues { $0.name }
    }

    func toggleFavorite(movieId: Int, movieName: String) {
        if favorites[movieId] != nil {
            favorites.removeValue(forKey: movieId)
        } else {
            favorites[movieId] = Favorite(name: movieName, dateAdded: Date())
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favorites[movieId] != nil
    }

    func getFavoritesSortedByMostRecent() -> [(id: Int, name: String)] {
        return favorites
            .sorted { $0.value.dateAdded > $1.value.dateAdded }
            .map { ($0.key, $0.value.name) }
    }

    func clearFavorites() {
        UserDefaults.standard.removeObject(forKey: favoritesKey)
    }
}

