//
//  DashboardViewController.swift
//  Movies
//
//  Created by Alejandro Villalobos on 23-11-23.
//

import UIKit

class DashboardViewController: UIViewController {
    var viewModel: DashboardViewModel?
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Find your movies"
        label.textColor = UIColor(named: "textColor")
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Here ..."
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = UIColor(named: "textColor")
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let categorySegmentedControl = UISegmentedControl(items: ["Top Rated", "Popular", "Action"])
    let moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let loadMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load More", for: .normal)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        return button
    }()
    
    let watchListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "primaryAccentColor")
        button.setTitle("Watch List", for: .normal)
        button.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)

        if let image = UIImage(named: "bi_bookmark.empty")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(named: "backgroundColor") // Set the desired tint color here
        }
        button.layer.cornerRadius = 16

        // Set title and image for the right side of the button
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

        // Adjust the insets to position the image to the right of the text
        let spacing: CGFloat = 16 // the amount of spacing to appear between image and text
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        setupNavigationBar()
        
        // Initialize ViewModel
        viewModel = DashboardViewModel(networkManager: NetworkManager.shared())

        // Bind ViewModel
        viewModel?.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }

        // Fetch top-rated movies
        viewModel?.fetchMovies(category: MovieCategoryTopRated)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        view.addSubview(subtitleLabel)
        view.addSubview(searchBar)
        view.addSubview(categoriesLabel)
        view.addSubview(categorySegmentedControl)
        view.addSubview(moviesCollectionView)
        view.addSubview(loadMoreButton)
        view.addSubview(watchListButton)
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        moviesCollectionView.backgroundColor = .clear
    }
    
    func layoutViews() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        categoriesLabel.translatesAutoresizingMaskIntoConstraints = false
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        watchListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // Search Sub Title Button Constraints
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            //
            categoriesLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            categoriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Category Segmented Control Constraints
            categorySegmentedControl.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Movies Collection View Constraints
            moviesCollectionView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor, constant: 16),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: loadMoreButton.topAnchor),
            
            // Assuming we want the collection view to take most of the screen, leaving space for buttons at the bottom
            moviesCollectionView.bottomAnchor.constraint(equalTo: loadMoreButton.topAnchor, constant: -16),
            
            // Load More Button Constraints
            loadMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loadMoreButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            loadMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loadMoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Watch List Button Constraints - placed next to Load More button
            watchListButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            watchListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            watchListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            watchListButton.heightAnchor.constraint(equalToConstant: 50),
            watchListButton.widthAnchor.constraint(equalTo: loadMoreButton.widthAnchor) // Same width as Load More Button
        ])
    }
}

extension DashboardViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to dequeue MovieCollectionViewCell")
        }

        if let movie = viewModel?.movie(at: indexPath) as? Result {
            cell.configure(with: movie)
        }
        
        return cell
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
