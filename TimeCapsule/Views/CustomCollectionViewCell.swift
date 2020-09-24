//
//  CustomCollectionViewCell.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-12.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell{
    
    // MARK: - Properties
    static var identifier: String = "Cell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 20)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateToShowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 20)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var indicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var image: Bool? {
        didSet {
            guard let image = image else { return }
            if image {
                indicatorImgView.image = UIImage(named: "indicatorImg")
            } else {
                indicatorImgView.image = nil
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setupView() {
        self.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        self.layer.cornerRadius = 25
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(dateToShowLabel)
        dateToShowLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateToShowLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
        
        self.addSubview(indicatorImgView)
        indicatorImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorImgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        indicatorImgView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        indicatorImgView.widthAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
    
}
