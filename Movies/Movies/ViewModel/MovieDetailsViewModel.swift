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
    @Published var reviews: [Review] = []
    @Published var currentPage: Int = 1
    @Published var reviewsLoaded: Bool = false // Added property to track reviews loaded
    @Published var isBackdropLoading: Bool = true
    @Published var isPosterLoading: Bool = true
    @Published var selectedTab: DetailsTab = .about

    private var networkManager: NetworkManager
    
    
    var isFavorite: Bool {
        FavoritesManager.shared.isFavorite(movieId: movie.id ?? 0)
    }
    
    init(movieId: Int) {
        movie = Result(author: nil, authorDetails: nil, adult: nil, backdropPath: nil, content: nil, createdAt: nil, genres: nil, genreIDS: nil, id: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, releaseDate: nil, title: nil, updatedAt: nil, url: nil, video: nil, voteAverage: nil, voteCount: nil)
        networkManager = NetworkManager.shared()
        fetchMovieDetails(movieId: movieId)
    }

    // Toggle favorite status
    func toggleFavorite() {
        guard let movieId = movie.id, let movieName = movie.title else { return }
        FavoritesManager.shared.toggleFavorite(movieId: movieId, movieName: movieName)
        // Notifying the view about the change
        self.objectWillChange.send()
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

    func fetchReviews(movieId: Int, page: Int) {
        isLoading = true
        networkManager.fetchMovieRatings(forId: movieId, page: page) { [weak self] data, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let self = self else { return }

                if let error = error {
                    // Handle error
                    return
                }

                guard let data = data else {
                    // Handle no data received
                    return
                }

                do {
                    let reviewsResponse = try JSONDecoder().decode(ReviewsResponse.self, from: data)
                    self.reviews.append(contentsOf: reviewsResponse.results)
                    // Handle pagination if needed
                } catch {
                    // Handle decoding error
                }
            }
        }
    }
    
}
