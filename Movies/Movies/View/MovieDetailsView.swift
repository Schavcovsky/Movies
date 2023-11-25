//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Alejandro Villalobos on 25-11-23.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    let movie: Result
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Movie Banner Image
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdropPath ?? "")"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                // Movie Title
                Text(movie.title ?? "N/A")
                    .font(.title)
                    .fontWeight(.bold)

                // Action Buttons (Placeholder for actual actions)
                HStack {
                    ForEach(0..<4, id: \.self) { _ in
                        Button(action: {}) {
                            Text("Action")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }

                // Movie Overview
                VStack(alignment: .leading) {
                    Text("Overview:")
                        .font(.headline)
                        .padding(.vertical, 4)
                    
                    Text(movie.overview ?? "Description not available.")
                        .font(.subheadline)
                }
                
                // Other movie details like release date, rating, etc.
                HStack {
                    VStack(alignment: .leading) {
                        Text("Release Date:")
                            .bold()
                        Text(movie.releaseDate ?? "N/A")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Average Rating:")
                            .bold()
                        Text("\(movie.voteAverage?.description ?? "N/A")")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Rate Count:")
                            .bold()
                        Text("\(movie.voteCount?.description ?? "N/A")")
                    }
                }
            }
            .padding()
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
