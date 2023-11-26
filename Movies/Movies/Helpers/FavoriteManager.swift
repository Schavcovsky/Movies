//
//  FavoriteManager.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favorites"
    
    private var favorites: [Int: String] {
        get {
            if let data = UserDefaults.standard.data(forKey: favoritesKey),
               let stringKeyDictionary = (try? JSONSerialization.jsonObject(with: data)) as? [String: String] {
                return Dictionary(uniqueKeysWithValues: stringKeyDictionary.map { (Int($0) ?? 0, $1) })
            }
            return [:]
        }
        set {
            let stringKeyDictionary = Dictionary(uniqueKeysWithValues: newValue.map { (String($0), $1) })
            if let data = try? JSONSerialization.data(withJSONObject: stringKeyDictionary) {
                UserDefaults.standard.set(data, forKey: favoritesKey)
            }
        }
    }
    
    private init() {}
    
    func getFavorites() -> [Int: String] {
        return favorites
    }

    func toggleFavorite(movieId: Int, movieName: String) {
        if favorites.keys.contains(movieId) {
            favorites.removeValue(forKey: movieId)
        } else {
            favorites[movieId] = movieName
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favorites.keys.contains(movieId)
    }

    // Optional: Method to get the name of a favorited movie
    func getAllFavoriteMovieNames() -> [String] {
       return Array(favorites.values).sorted()
   }
}
