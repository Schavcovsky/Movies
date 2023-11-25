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
            VStack {
                GeometryReader { geometry in
                    // Background Image with parallax effect
                    if let backdropPath = viewModel.movie.backdropPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)") {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: getHeaderHeight(for: geometry))
                            .clipped()
                            .offset(y: getHeaderOffset(for: geometry))
                    }
                }
                .frame(height: 300) // Height for the background image

                // Horizontal stack for the poster image and movie title
                HStack(alignment: .top, spacing: 16) {
                    // Poster Image
                    if let posterPath = viewModel.movie.posterPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120) // Adjust width as needed
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding(.top, -100)
                    }
                   

                    // Movie Title and Genre Buttons
                    VStack(alignment: .leading, spacing: 8) {
                        // Movie Title
                        Text(viewModel.movie.title ?? "N/A")
                            .font(.title2)
                            .fontWeight(.bold)

                                            }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)

                // Movie Overview and Details
                VStack(alignment: .leading, spacing: 12) {
                    // Genre Buttons
                    if let genres = viewModel.movie.genres, !genres.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(genres, id: \.id) { genre in
                                    GenreButton(genre: genre)
                                }
                            }
                        }
                        .padding(.bottom)
                    }

                    // Movie Overview
                    Text("Overview:")
                        .font(.headline)
                    Text(viewModel.movie.overview ?? "Description not available.")
                        .font(.subheadline)

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
        .edgesIgnoringSafeArea(.top) // Allow background image to extend into the top safe area
        .background(Color("backgroundColor"))
    }

    func getHeaderHeight(for geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        let size = offset > 0 ? 300 + offset : 300
        return size
    }

    func getHeaderOffset(for geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        return offset > 0 ? -offset : 0
    }
}


// Genre button view
struct GenreButton: View {
    let genre: Genre

    var body: some View {
        Button(action: {
            // Action for genre button tap
        }) {
            Text(genre.name ?? "N/A")
                .padding(.vertical, 4)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color("secondaryAccentColor"))
                .cornerRadius(16)
        }
    }
}

// Detail item view
struct DetailItem: View {
    let title: String
    let value: String

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
