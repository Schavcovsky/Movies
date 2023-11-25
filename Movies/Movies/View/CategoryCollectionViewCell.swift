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
        label.text = "Category"
        return label
    }()
    
    let titleLabelContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "secondaryAccentColor")
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        return containerView
    }()
    
    var isActive: Bool = false {
        didSet {
            titleLabelContainer.backgroundColor = isActive ? UIColor(named: "primaryAccentColor") : UIColor(named: "secondaryAccentColor")
            titleLabel.textColor = isActive ? UIColor(named: "backgroundColor") : UIColor(named: "textColor")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            isActive = isSelected
        }
    }

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
            titleLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleLabelContainer.topAnchor, constant: 8), // Adjust top padding
            titleLabel.bottomAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor, constant: -8), // Adjust bottom padding
            titleLabel.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 24), // Adjust left padding
            titleLabel.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -24), // Adjust right padding
        ])
    }
    
    func configure(with category: String) {
        titleLabel.text = category
        layoutIfNeeded()
    }
}
