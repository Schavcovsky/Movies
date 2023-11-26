//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    private var favoritesMapping: [String: Int] = [:]

    @Published var favoriteMovies: [(id: Int, name: String)] = []

    func loadFavorites() {
        // Use the method that sorts by most recent
        favoriteMovies = FavoritesManager.shared.getFavoritesSortedByMostRecent()
    }

    func getMovieId(forName name: String) -> Int? {
        return favoritesMapping[name]
    }
}
