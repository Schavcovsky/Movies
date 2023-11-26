//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false        
        imageView.kf.indicatorType = .activity
        if let indicator = imageView.kf.indicator?.view as? UIActivityIndicatorView {
            indicator.style = .medium
            indicator.color = .gray
        }
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(named: "textColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "textColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let averageRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "textColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "heart.empty")
        let tintedImage = image?.withTintColor(UIColor(named: "secondaryAccentColor")!, renderingMode: .alwaysOriginal)
        button.setImage(tintedImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var movieId: Int?
    var movieName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(movieImageView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
        addSubview(averageRatingLabel)
        
        contentView.addSubview(favoriteButton)
        
        favoriteButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        favoriteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
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
            movieImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            movieImageView.widthAnchor.constraint(equalToConstant: fixedWidth),
                        
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -padding),
            
            // Release Date Label Constraints
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Average Rating Label Constraints
            averageRatingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: padding),
            averageRatingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            averageRatingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Checkmark Button Constraints
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            favoriteButton.widthAnchor.constraint(equalToConstant: iconSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: iconSize),
        ])
    }
    
    func configure(with result: Result) {
        titleLabel.text = "Title:\n" + (result.title ?? "N/A")
        releaseDateLabel.text = "Release Date:\n" + (result.releaseDate ?? "N/A")
        averageRatingLabel.text = "Average Rating:\n" + String(format: "%.1f", result.voteAverage ?? 0.0)
        configureFavoriteButton(movieId: result.id ?? 0)
        self.movieId = result.id
        self.movieName = result.title
        
        if let posterPath = result.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            movieImageView.kf.setImage(with: url)
        } else {
            movieImageView.image = UIImage(named: "image_not_available")
        }
    }
    
    func configureFavoriteButton(movieId: Int) {
        let isFavorite = FavoritesManager.shared.isFavorite(movieId: movieId)
        let imageName = isFavorite ? "heart.filled" : "heart.empty"
        let image = UIImage(named: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite ? nil : UIColor(named: "secondaryAccentColor")
    }
    
    @objc private func favoriteButtonTapped() {
        if let movieId = self.movieId, let movieName = self.movieName {
            FavoritesManager.shared.toggleFavorite(movieId: movieId, movieName: movieName)
            configureFavoriteButton(movieId: movieId)
        }
    }
}
