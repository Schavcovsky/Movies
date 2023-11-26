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
        Group {
            if viewModel.favoriteMovies.isEmpty {
                // Display a message when the list is empty
                Text("You haven't marked any movies as Favorite yet.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(viewModel.favoriteMovies, id: \.self) { movie in
                    if let movieId = viewModel.getMovieId(forName: movie) {
                        NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: movieId))) {
                            Text(movie)
                        }
                    }
                }
            }
        }
        .onAppear(perform: viewModel.loadFavorites)
        .navigationBarTitle("Favorites", displayMode: .large)
    }
}

// Preview
#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
#endif
