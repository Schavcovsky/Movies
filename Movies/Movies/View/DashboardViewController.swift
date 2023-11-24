//
//  DashboardViewController.swift
//  Movies
//
//  Created by Alejandro Villalobos on 23-11-23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Here ..."
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    let categorySegmentedControl = UISegmentedControl(items: ["Top Rated", "Popular", "Action"])
    let moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let loadMoreButton = UIButton(type: .system)
    let watchListButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        // Configure the search bar
        searchBar.placeholder = "Search Here ..."
        
        // Configure the segmented control
        categorySegmentedControl.selectedSegmentIndex = 0
        
        // Configure the collection view
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        // Configure the buttons
        loadMoreButton.setTitle("Load More", for: .normal)
        watchListButton.setTitle("Watch List", for: .normal)
        
        // Add subviews
        view.addSubview(searchBar)
        view.addSubview(categorySegmentedControl)
        view.addSubview(moviesCollectionView)
        view.addSubview(loadMoreButton)
        view.addSubview(watchListButton)
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        moviesCollectionView.backgroundColor = .clear
    }
    
    func layoutViews() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        watchListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Category Segmented Control Constraints
            categorySegmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            // Movies Collection View Constraints
            moviesCollectionView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: loadMoreButton.topAnchor),
            
            // Assuming we want the collection view to take most of the screen, leaving space for buttons at the bottom
            moviesCollectionView.bottomAnchor.constraint(equalTo: loadMoreButton.topAnchor, constant: -10),
            
            // Load More Button Constraints
            loadMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loadMoreButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            loadMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            loadMoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Watch List Button Constraints - placed next to Load More button
            watchListButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            watchListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            watchListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            watchListButton.heightAnchor.constraint(equalToConstant: 50),
            watchListButton.widthAnchor.constraint(equalTo: loadMoreButton.widthAnchor) // Same width as Load More Button
        ])
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of mock data items
        return mockMoviesData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to dequeue MovieCollectionViewCell")
        }
        // Configure the cell with mock data
        let movie = mockMoviesData()[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    private func mockMoviesData() -> [Movie] {
        // Create an array of mock movies
        let movies = [
            Movie(title: "Avengers End Game", releaseDate: "2019-08-03", rating: 9.5, posterImageName: "endgame"),
            Movie(title: "Spiderman No Way Home", releaseDate: "2021-12-17", rating: 9.5, posterImageName: "spiderman")
        ]
        return movies
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 10
        let width = collectionView.bounds.width - (padding * 2)
        let height: CGFloat = 120
        
        return CGSize(width: width, height: height)
    }
}

































// New File
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let averageRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let checkmarkButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let starRatingButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(systemName: "star.fill", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(movieImageView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
        addSubview(averageRatingLabel)
        
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(starRatingButton)
        
        checkmarkButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        checkmarkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        starRatingButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        starRatingButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupConstraints() {
        // Constants for padding and icon size
        let padding: CGFloat = 8
        let iconSize: CGFloat = 20
        let fixedWidth: CGFloat = 100
        
        NSLayoutConstraint.activate([
            // Movie Image View Constraints
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            movieImageView.widthAnchor.constraint(equalToConstant: fixedWidth),
                        
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding - iconSize * 2),
            
            // Release Date Label Constraints
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Average Rating Label Constraints
            averageRatingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: padding),
            averageRatingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            averageRatingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Checkmark Button Constraints
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            checkmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            checkmarkButton.widthAnchor.constraint(equalToConstant: iconSize),
            checkmarkButton.heightAnchor.constraint(equalToConstant: iconSize),
            
            // Star Rating Button Constraints
            starRatingButton.topAnchor.constraint(equalTo: checkmarkButton.bottomAnchor, constant: padding),
            starRatingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            starRatingButton.widthAnchor.constraint(equalToConstant: iconSize),
            starRatingButton.heightAnchor.constraint(equalToConstant: iconSize),
        ])
    }
    
    func configure(with movie: Movie) {
        
        titleLabel.text = "Title:\n" + movie.title
        releaseDateLabel.text = "Release Date:\n" + movie.releaseDate
        averageRatingLabel.text = "Average Rating:\n" + String(format: "%.1f", movie.rating)
        movieImageView.image = UIImage(named: movie.posterImageName)
    }
}

// If you have not already defined a Movie model, you would define it like this:
struct Movie {
    var title: String
    var releaseDate: String
    var rating: Double
    var posterImageName: String
}

