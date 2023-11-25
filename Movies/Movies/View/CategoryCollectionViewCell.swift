//
//  CategoryCollectionViewCell.swift
//  Movies
//
//  Created by Alejandro Villalobos on 25-11-23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "textColor")
        label.text = "Category" // Set your default text here
        return label
    }()
    
    let titleLabelContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "primaryAccentColor")
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        return containerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabelContainer)
        titleLabelContainer.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabelContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabelContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: titleLabelContainer.topAnchor, constant: 8), // Adjust top padding
            titleLabel.bottomAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor, constant: -8), // Adjust bottom padding
            titleLabel.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 16), // Adjust left padding
            titleLabel.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -16), // Adjust right padding
        ])
    }
    
    func configure(with category: String) {
        titleLabel.text = category
        layoutIfNeeded() // Call this to ensure your layout is updated
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabelContainer.backgroundColor = isSelected ? UIColor(named: "primaryAccentColor") : UIColor(named: "secondaryAccentColor")
            titleLabel.textColor = isSelected ? UIColor(named: "backgroundColor") : UIColor(named: "textColor")
        }
    }
}
