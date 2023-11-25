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
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.backgroundColor = UIColor(named: "secondaryAccentColor")
        button.tintColor = UIColor(named: "textColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.layer.cornerRadius = 8
        return button
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
    
    let decreaseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.backgroundColor = UIColor(named: "secondaryAccentColor")
        button.tintColor = UIColor(named: "textColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.layer.cornerRadius = 8
        return button
    }()

    let increaseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.backgroundColor = UIColor(named: "secondaryAccentColor")
        button.tintColor = UIColor(named: "textColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.layer.cornerRadius = 8
        return button
    }()

    /*
    let loadMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load More", for: .normal)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        return button
    }()
     */
    
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
        viewModel?.fetchMovies(category: MovieCategoryTopRated, page: viewModel?.currentPage ?? 1)
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
        watchListButton.setTitle("Watch List", for: .normal)
        
        // Add subviews
        view.addSubview(subtitleLabel)
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        view.addSubview(categoriesLabel)
        view.addSubview(categorySegmentedControl)
        view.addSubview(moviesCollectionView)
        view.addSubview(decreaseButton)
        view.addSubview(increaseButton)
        view.addSubview(watchListButton)
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        moviesCollectionView.backgroundColor = .clear
        
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
    }
    
    func layoutViews() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        categoriesLabel.translatesAutoresizingMaskIntoConstraints = false
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        watchListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // Search Sub Title Button Constraints
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
            
            // Assuming we want the collection view to take most of the screen, leaving space for buttons at the bottom
            moviesCollectionView.bottomAnchor.constraint(equalTo: decreaseButton.topAnchor, constant: -16),
            
            // Decrease Button Constraints
            decreaseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            decreaseButton.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -16),
            decreaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            decreaseButton.heightAnchor.constraint(equalToConstant: 50),
            decreaseButton.widthAnchor.constraint(equalTo: watchListButton.widthAnchor, multiplier: 0.5, constant: -20),
            
            // Increase Button Constraints
            increaseButton.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 16),
            increaseButton.trailingAnchor.constraint(equalTo: watchListButton.leadingAnchor, constant: -16),
            increaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            increaseButton.heightAnchor.constraint(equalToConstant: 50),
            increaseButton.widthAnchor.constraint(equalTo: watchListButton.widthAnchor, multiplier: 0.5, constant: -20),
            
            // Watch List Button Constraints - placed next to Load More button
            watchListButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            watchListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            watchListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            watchListButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func decreaseButtonTapped() {
        viewModel?.currentPage -= 1
        if let currentPage = viewModel?.currentPage {
            viewModel?.fetchMovies(category: MovieCategoryTopRated, page: currentPage)
        }
    }
    
    @objc func increaseButtonTapped() {
        viewModel?.currentPage += 1
        if let currentPage = viewModel?.currentPage {
            viewModel?.fetchMovies(category: MovieCategoryTopRated, page: currentPage)
        }
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
