//
//  FavoritesView.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = FavoritesViewModel()

    var body: some View {
        List(viewModel.favoriteMovies, id: \.self) { movie in
            if let movieId = viewModel.getMovieId(forName: movie) {
                NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: movieId))) {
                    Text(movie)
                }
            }
        }
        .onAppear(perform: viewModel.loadFavorites)
        .navigationBarTitle("Favorites", displayMode: .large)
    }
}

// Preview
#Preview {
    FavoritesView()
}
