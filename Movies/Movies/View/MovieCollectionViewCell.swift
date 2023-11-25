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
    
    private let checkmarkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bi_bookmark.empty")
        let tintedImage = image?.withTintColor(UIColor(named: "secondaryAccentColor")!, renderingMode: .alwaysOriginal)
        button.setImage(tintedImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let starRatingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "clarity_star.empty")
        let tintedImage = image?.withTintColor(UIColor(named: "secondaryAccentColor")!, renderingMode: .alwaysOriginal)
        button.setImage(tintedImage, for: .normal)
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
            movieImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            movieImageView.widthAnchor.constraint(equalToConstant: fixedWidth),
                        
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkButton.leadingAnchor, constant: -padding),
            
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
    
    func configure(with result: Result) {
        titleLabel.text = "Title:\n" + (result.title ?? "N/A")
        releaseDateLabel.text = "Release Date:\n" + (result.releaseDate ?? "N/A")
        averageRatingLabel.text = "Average Rating:\n" + String(format: "%.1f", result.voteAverage ?? 0.0)

        if let posterPath = result.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            movieImageView.kf.setImage(with: url)
        } else {
            movieImageView.image = nil // Set a default image or leave it empty
        }
    }
}
