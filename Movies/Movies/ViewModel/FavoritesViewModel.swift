//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [String] = []

    private var favoritesMapping: [String: Int] = [:]

    func loadFavorites() {
        let favorites = FavoritesManager.shared.getFavorites() // Updated to use getFavorites method
        favoriteMovies = favorites.map { $0.value }.sorted()
        favoritesMapping = Dictionary(uniqueKeysWithValues: favorites.map { ($0.value, $0.key) })
    }

    func getMovieId(forName name: String) -> Int? {
        return favoritesMapping[name]
    }
}
