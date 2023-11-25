//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Alejandro Villalobos on 25-11-23.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Movie Banner Image
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.movie.backdropPath ?? "")"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                // Movie Title
                Text(viewModel.movie.title ?? "N/A")
                    .font(.title)
                    .fontWeight(.bold)

                // Genre Buttons
                if let genres = viewModel.movie.genres, !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(genres, id: \.id) { genre in
                                Button(action: {
                                    // Action for genre button tap
                                }) {
                                    Text(genre.name ?? "N/A")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }

                // Movie Overview
                VStack(alignment: .leading) {
                    Text("Overview:")
                        .font(.headline)
                        .padding(.vertical, 4)
                    
                    Text(viewModel.movie.overview ?? "Description not available.")
                        .font(.subheadline)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        DetailItem(title: "Release Date:", value: viewModel.movie.releaseDate ?? "N/A")
                        DetailItem(title: "Average Rating:", value: viewModel.movie.voteAverage?.description ?? "N/A")
                    }
                    
                    VStack(alignment: .leading) {
                        DetailItem(title: "Rate Count:", value: viewModel.movie.voteCount?.description ?? "N/A")
                        DetailItem(title: "Popularity:", value: viewModel.movie.popularity?.description ?? "N/A")
                    }
                }
            }
            .padding()
        }
    }
}

// Assuming Genre conforms to Identifiable by using its 'id' property
extension Genre: Identifiable {}

// Create a subview for the detail items to avoid repetition
struct DetailItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
            Text(value)
        }
    }
}

/*
struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sampleMovie = Result(
            adult: false,
            backdropPath: "placeholder_image", // Example backdrop path
            genreIDS: [28, 12],
            id: 123456,
            originalLanguage: "en",
            originalTitle: "Sample Movie",
            overview: "This is a sample overview of the movie.",
            popularity: 8.9,
            posterPath: "/pathToPoster.jpg",
            releaseDate: "2022-01-01",
            title: "Sample Movie",
            video: false,
            voteAverage: 7.5,
            voteCount: 200
        )

        // Previewing the MovieDetailsView with the sample movie
        MovieDetailsView(movie: sampleMovie)
    }
}
*/
