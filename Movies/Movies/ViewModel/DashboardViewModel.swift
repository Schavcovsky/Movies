//
//  DashboardViewModel.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

import Foundation

class DashboardViewModel {
    
    // Properties to hold data that the view will display
    var movies: [Result] = [] {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    var numberOfItems: Int {
        return movies.count
    }
    
    // Closures for binding
    var reloadCollectionViewClosure: (()->())?
    
    // Inject the network manager (defined in Objective-C and used via a bridging header)
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // Fetching movies
    func fetchMovies(category: String) {
        networkManager.fetchMovies(forCategory: category) { [weak self] (data, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Decode the outer structure (Movie) which contains the array of Results
                let movieResponse = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    // Assign the results to the movies property
                    self.movies = movieResponse.results ?? []
                }
            } catch {
                print("Error decoding movies: \(error)")
            }
        }
    }
    
    // Get a movie for a particular index path
    func movie(at indexPath: IndexPath) -> Result {
        return movies[indexPath.item]
    }
}
