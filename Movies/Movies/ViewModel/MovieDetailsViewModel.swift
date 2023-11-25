//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Alejandro Villalobos on 25-11-23.
//

import Foundation

final class MovieDetailsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var movie: Result
    private var networkManager: NetworkManager

    init() {
        // Initialize an empty Result object
        movie = Result(author: nil, authorDetails: nil, adult: nil, backdropPath: nil, content: nil, createdAt: nil, genres: nil, genreIDS: nil, id: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, releaseDate: nil, title: nil, updatedAt: nil, url: nil, video: nil, voteAverage: nil, voteCount: nil)
        networkManager = NetworkManager.shared()
    }

    func fetchMovieDetails(movieId: Int) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        networkManager.fetchMovieDetails(forId: movieId) { [weak self] data, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching movie details: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received for movie details")
                    return
                }

                do {
                    let details = try JSONDecoder().decode(Result.self, from: data)
                    self.movie = details
                } catch {
                    print("Error decoding movie details: \(error)")
                }
            }
        }
    }

    func fetchMovieRatings(movieId: Int, pageNumber: Int) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        networkManager.fetchMovieRatings(forId: movieId, page: pageNumber) { [weak self] data, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let self = self else { return }

                // Handle the response
                // Parse data and update relevant properties
            }
        }
    }
}
