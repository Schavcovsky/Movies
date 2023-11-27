//
//  DashboardViewModel.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

import Foundation

protocol DashboardViewModelProtocol {
    func retryLastFetch()
    func fetchMovies(category: String, page: Int)
    func searchMovies(query: String, page: Int)
    func movie(at indexPath: IndexPath) -> Result
    func performSearch(withQuery query: String)
}

class DashboardViewModel: DashboardViewModelProtocol {
    
    var isLoading = false
    var movies: [Result] = [] {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var numberOfItems: Int {
        return movies.count
    }
    var currentPage: Int = 1
    var categories: [MovieCategory] = [.topRated, .nowPlaying, .popular, .upcoming]
    var activeCategoryIndex: Int = 0 {
        didSet {
            // Update the active category index and reload the collection view
            self.reloadCollectionViewClosure?()
        }
    }    
    var isSearchMode: Bool = false
    var searchQuery: String?
    // Closures for binding
    var reloadCollectionViewClosure: (()->())?
    var showErrorAlertClosure: ((String) -> ())?
    // Inject the network manager (defined in Objective-C and used via a bridging header)
    let networkManager: NetworkManager
    
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.isLoading = true
    }
    
    func retryLastFetch() {
        let category = categories[activeCategoryIndex].rawValue
        fetchMovies(category: category, page: currentPage)
    }
    
    // Fetching movies
    func fetchMovies(category: String, page: Int) {
        let searchCategory = isSearchMode ? MovieSearch : category
        networkManager.fetchMovies(forCategory: searchCategory, query: searchQuery ?? "", page: page) { [weak self] (data, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlertClosure?("Error fetching movies: \(error.localizedDescription)")
                }
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
                    self.isLoading = false
                }
            } catch {
                print("Error decoding movies: \(error)")
            }
        }
    }
    
    func searchMovies(query: String, page: Int) {
        isSearchMode = true
        searchQuery = query
        networkManager.fetchMovies(forCategory: MovieSearch, query: query, page: page) { [weak self] (data, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error searching movies: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlertClosure?("Error fetching movies: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                print("No data received from search")
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    self.movies = movieResponse.results ?? []
                    self.isLoading = false
                }
            } catch {
                print("Error decoding search results: \(error)")
            }
        }
    }
    
    // Get a movie for a particular index path
    func movie(at indexPath: IndexPath) -> Result {
        return movies[indexPath.item]
    }
    
    func performSearch(withQuery query: String) {
        currentPage = 1
        searchQuery = query
        isSearchMode = true
        searchMovies(query: query, page: currentPage)
    }
}
