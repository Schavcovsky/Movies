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

protocol FavoritesViewModelProtocol {
    func loadFavorites()
}

final class FavoritesViewModel: ObservableObject, FavoritesViewModelProtocol {
    @Published var favoriteMovies: [(id: Int, name: String)] = []
    
    func loadFavorites() {
        favoriteMovies = FavoritesManager.shared.getFavoritesSortedByMostRecent()
    }
}
