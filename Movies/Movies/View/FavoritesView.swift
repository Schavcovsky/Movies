//
//  FavoritesView.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        Group {
            if viewModel.favoriteMovies.isEmpty {
                Text("You haven't marked any movies as Favorite yet.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                movieList
            }
        }
        .onAppear(perform: viewModel.loadFavorites)
        .navigationBarTitle("Favorites", displayMode: .large)
    }
    
    private var movieList: some View {
        List(viewModel.favoriteMovies, id: \.id) { favorite in
            NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: favorite.id))) {
                Text(favorite.name)
            }
        }
    }
}

// Preview
#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: FavoritesViewModel())
    }
}
#endif
