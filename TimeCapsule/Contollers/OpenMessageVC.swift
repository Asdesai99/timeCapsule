//
//  OpenMessageVC.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-08-12.
//

import UIKit

class OpenMessageVC: UIViewController {
    
    // MARK: - Properties
    enum Section {
        case main
    }
    
    var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos: "
        label.font = UIFont(name: "Futura", size: 20)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var collectionView: UICollectionView! = nil
    
    var titleText: String?
    
    var databaseManager: DatabaseManager!
    
    var dataStore: DataStore!
    
    var message: String!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>! = nil
    
    var imageArray = [UIImage]()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    let fadeView = UIView()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        setupDataSource()
        
        self.collectionView.register(CustomPhotoCell.self, forCellWithReuseIdentifier: CustomPhotoCell.reuseIdentifier)
        
        setupView()
        guard let titleText = titleText else { return }
        print(titleText)
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        System.clearNavigationBar(forBar: self.navigationController!.navigationBar)
        self.navigationController?.navigationBar.isHidden = false
    }
    // MARK: - SetupView
    func setupView() {
        view.backgroundColor = UIColor(named: "whiteBackgroundColour")
        
        self.view.addSubview(collectionView)
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: screen.height/4.31).isActive = true
        
        self.view.addSubview(photoLabel)
        photoLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -5).isActive = true
        photoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screen.minusNumber/2).isActive = true
        
        
        // add activity to main view
        self.view.addSubview(fadeView)
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.heightAnchor.constraint(equalTo: collectionView.heightAnchor).isActive = true
        fadeView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        fadeView.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        fadeView.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        fadeView.backgroundColor = UIColor.black
        fadeView.layer.opacity = 0.1
        
        self.collectionView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    
    
    func getMessage() -> String {
        self.message = ""
        message = databaseManager.getMessage(for: titleText!)
        return message
    }
}


// MARK: - setup Datasources
extension OpenMessageVC {
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        view.addSubview(collectionView)
    }
    
    func updateDataSource(_ imageArray: [UIImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(imageArray)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
                self.dataSource.apply(snapshot, animatingDifferences: true)

            }, completion: nil)
            self.activityIndicator.stopAnimating()
            self.fadeView.removeFromSuperview()
        }
    }
    
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource <Section, UIImage>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, image: UIImage) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomPhotoCell.reuseIdentifier, for: indexPath) as! CustomPhotoCell
            cell.image.image = image
            return cell
        }
        
        let imageURLarray = databaseManager.getPhotoNames(forTitle: titleText!)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.imageArray = self.dataStore.getImageFromDocumentDirectory(paths: imageURLarray)
            self.updateDataSource(self.imageArray)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(imageArray)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
}

// MARK: - collectionview delegate
extension OpenMessageVC: UICollectionViewDelegate {
    
}


// MARK: - collectionview flow layout
extension OpenMessageVC: UICollectionViewDelegateFlowLayout {
    
}
