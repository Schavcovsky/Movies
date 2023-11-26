//
//  FavoritesView.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import SwiftUI

import SwiftUI

struct FavoritesView: View {
    @State private var favoriteMovies: [String] = []

    var body: some View {
        List(favoriteMovies, id: \.self) { movie in
            Text(movie)
        }
        .onAppear(perform: loadFavorites)
        .navigationBarTitle("Favorites", displayMode: .inline)
    }

    private func loadFavorites() {
        favoriteMovies = FavoritesManager.shared.getAllFavoriteMovieNames()
    }
}

#Preview {
    FavoritesView()
}
