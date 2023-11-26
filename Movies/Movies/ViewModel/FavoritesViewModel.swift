//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

protocol FavoritesViewFactory {
    func makeFavoritesView() -> FavoritesView
}

class DefaultFavoritesViewFactory: FavoritesViewFactory {
    func makeFavoritesView() -> FavoritesView {
        let viewModel = SceneDelegate.container.resolve(FavoritesViewModel.self)!
        return FavoritesView(viewModel: viewModel)
    }
}


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
