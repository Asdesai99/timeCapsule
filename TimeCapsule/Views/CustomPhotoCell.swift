//
//  CustomPhotoCell.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-08-20.
//

import UIKit

class CustomPhotoCell: UICollectionViewCell {
    let image = UIImageView()
    static let reuseIdentifier = "photo-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension CustomPhotoCell {
    func configure() {
        self.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.gray.cgColor
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}
