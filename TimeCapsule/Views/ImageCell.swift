//
//  ImageCell.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-20.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier: String = "cell"
    
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            imageView.image = image
        }
    }
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let selectedImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    var isInEditingMode: Bool = false {
        didSet {
            selectedImageView.image = UIImage(named: "checkmark2")
        }
    }

    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                setupView()
                blurView.isHidden = !isSelected
                selectedImageView.isHidden = !isSelected
            } else {
                blurView.removeFromSuperview()
                selectedImageView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.layer.cornerRadius = cornerRadius()
        imageView.layer.cornerRadius = cornerRadius() - 2
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        if self.isInEditingMode {
          //  setupView()
        } else {
     
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    func setupView() {

        
        self.addSubview(blurView)
        blurView.backgroundColor = .white
        blurView.layer.cornerRadius = cornerRadius()-3
        blurView.layer.opacity = 0.5
        blurView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blurView.isHidden = true
        
        self.addSubview(selectedImageView)
        selectedImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        selectedImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        selectedImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        selectedImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectedImageView.isHidden = true

    }
    
}
