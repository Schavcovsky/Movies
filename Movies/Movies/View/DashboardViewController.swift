//
//  DashboardViewController.swift
//  Movies
//
//  Created by Alejandro Villalobos on 23-11-23.
//

import SwiftUI
import Swinject

class DashboardViewController: UIViewController, UISearchBarDelegate {
    var container: Container!
    var viewModel: DashboardViewModel?
    var connectivityManager: ConnectivityManager?
    let spinner = UIActivityIndicatorView(style: .large)
    
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
    
    let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
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
    
    let watchListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "primaryAccentColor")
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        
        if let image = UIImage(named: "heart.filled")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(named: "backgroundColor")
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
        
        setupUI()
        updateButtonStates()
        setupBindings()
        setupConnectivity()
        setupGestures()
        initialDataFetch()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        setupViews()
        layoutViews()
        setupNavigationBar()
        spinner.startAnimating()
    }
    
    private func setupBindings() {
        viewModel?.reloadCollectionViewClosure = { [weak self] in
            self?.updateUIOnViewModelUpdate()
        }
        
        viewModel?.showErrorAlertClosure = { [weak self] errorMessage in
            self?.showErrorAlert(withMessage: errorMessage)
        }
    }
    
    private func setupConnectivity() {
        connectivityManager?.delegate = self
        connectivityManager?.startMonitoring()
        checkInternetConnectivity()
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        watchListButton.addTarget(self, action: #selector(watchListButtonTapped), for: .touchUpInside)
    }
    
    private func initialDataFetch() {
        let defaultCategory = viewModel?.categories.first ?? .topRated
        viewModel?.activeCategoryIndex = viewModel?.categories.firstIndex(of: defaultCategory) ?? 0
        viewModel?.fetchMovies(category: defaultCategory.rawValue, page: viewModel?.currentPage ?? 1)
        
        searchBar.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        selectInitialCategory()
    }
    
    // MARK: - Additional Functions
    
    private func updateUIOnViewModelUpdate() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
            if self.viewModel?.isLoading == false {
                self.spinner.stopAnimating()
            }
        }
    }
    
    private func checkInternetConnectivity() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !(self.connectivityManager?.isConnected ?? false) {
                self.showNoInternetAlert()
            }
        }
    }
    
    private func selectInitialCategory() {
        let firstCategoryIndexPath = IndexPath(item: 0, section: 0)
        categoriesCollectionView.selectItem(at: firstCategoryIndexPath, animated: false, scrollPosition: .left)
        collectionView(categoriesCollectionView, didSelectItemAt: firstCategoryIndexPath)
    }
    
    private func stopSpinnerIfNeeded() {
        if viewModel?.isLoading == false {
            spinner.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moviesCollectionView.reloadData()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        // Configure the Categories collection view
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        // Configure the collection view
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        // Add subviews
        view.addSubview(spinner)
        view.addSubview(subtitleLabel)
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        view.addSubview(categoriesLabel)
        view.addSubview(categoriesCollectionView)
        view.addSubview(moviesCollectionView)
        view.addSubview(decreaseButton)
        view.addSubview(increaseButton)
        view.addSubview(watchListButton)
    }
    
    func layoutViews() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        categoriesLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        watchListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: moviesCollectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: moviesCollectionView.centerYAnchor),
            
            // Search Sub Title Button Constraints
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            
            // Search Button Constraints
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Category Label View Constraints
            categoriesLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            categoriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Category Collection View Constraints
            categoriesCollectionView.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 8),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            // Movies Collection View Constraints
            moviesCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 16),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            
            // Watch List Button Constraints
            watchListButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            watchListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            watchListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            watchListButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func searchButtonTapped() {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        viewModel?.performSearch(withQuery: query)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel?.currentPage = 1
        viewModel?.searchQuery = query
        viewModel?.isSearchMode = true
        viewModel?.searchMovies(query: query, page: viewModel?.currentPage ?? 1)
        
        categoriesCollectionView.reloadData()
        updateButtonStates()
    }
    
    private func showErrorAlert(withMessage message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @objc func viewTapped() {
        searchBar.resignFirstResponder()
    }
    
    @objc func decreaseButtonTapped() {
        guard let viewModel = viewModel, viewModel.currentPage > 1 else { return }
        viewModel.currentPage -= 1
        let category = viewModel.categories[viewModel.activeCategoryIndex]
        viewModel.fetchMovies(category: category.rawValue, page: viewModel.currentPage)
        updateButtonStates()
    }
    
    @objc func increaseButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.currentPage += 1
        let category = viewModel.categories[viewModel.activeCategoryIndex]
        viewModel.fetchMovies(category: category.rawValue, page: viewModel.currentPage)
        updateButtonStates()
    }
    
    @objc func watchListButtonTapped() {
        guard let factory = SceneDelegate.container.resolve(FavoritesViewFactory.self) else { return }
        let favoritesView = factory.makeFavoritesView()
        let hostingController = UIHostingController(rootView: favoritesView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func updateButtonStates() {
        decreaseButton.isEnabled = viewModel?.currentPage ?? 1 > 1
        decreaseButton.tintColor = decreaseButton.isEnabled ? UIColor(named: "textColor") : .gray
    }
}

// Extend DashboardViewController
extension DashboardViewController: ConnectivityDelegate {
    func didChangeConnectionStatus(connected: Bool) {
        if connected {
            viewModel?.retryLastFetch()
        } else {
            showNoInternetAlert()
        }
    }
    
    private func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return viewModel?.categories.count ?? 0
        } else {
            return viewModel?.movies.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            let category = viewModel?.categories[indexPath.item]
            cell.configure(with: category?.displayName ?? "")
            
            // Directly use the isActive property to set the cell appearance based on selection
            cell.isActive = viewModel?.isSearchMode == false && indexPath.item == viewModel?.activeCategoryIndex
            
            return cell
        } else {
            // Handle the cells for moviesCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
            if let movie = viewModel?.movie(at: indexPath) {
                cell.configure(with: movie)
                cell.movieId = movie.id
                cell.movieName = movie.title
            }
            return cell
        }
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

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moviesCollectionView {
            if collectionView == moviesCollectionView {
                if let movie = viewModel?.movie(at: indexPath) {
                    guard let factory = SceneDelegate.container.resolve(MovieDetailsViewModelFactory.self) else { return }
                    let movieDetailsViewModel = factory.makeMovieDetailsViewModel(movieId: movie.id ?? 0)
                    
                    let detailsView = MovieDetailsView(viewModel: movieDetailsViewModel)
                    let hostingController = UIHostingController(rootView: detailsView)
                    self.navigationController?.pushViewController(hostingController, animated: true)
                }
            }
        } else {
            viewModel?.isSearchMode = false
            viewModel?.searchQuery = nil
            viewModel?.activeCategoryIndex = indexPath.item
            viewModel?.currentPage = 1
            
            let selectedCategory = viewModel?.categories[indexPath.item]
            viewModel?.fetchMovies(category: selectedCategory?.rawValue ?? "", page: viewModel?.currentPage ?? 1)
            
            searchBar.text = ""
            searchBar.resignFirstResponder()
            
            // Reload categoriesCollectionView to update selection appearance
            categoriesCollectionView.reloadData()
            
            // Call updateButtonStates to ensure decreaseButton is updated
            updateButtonStates()
        }
    }
}
