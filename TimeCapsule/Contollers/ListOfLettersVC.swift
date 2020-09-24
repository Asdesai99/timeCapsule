//
//  ViewController.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-11.
//

import UIKit
import UserNotifications

class ListOfLettersVC: UIViewController {
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let cV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cV.delegate = self
        cV.backgroundColor = UIColor(named: "whiteBackgroundColour")
        cV.translatesAutoresizingMaskIntoConstraints = false
        return cV
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Future Messages"
        label.font = UIFont(name: "Futura", size: 32)
        label.textAlignment = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addMessageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleAddTapped), for: .touchUpInside)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var vc: TitleVC!
    
    weak var addMessageVC: AddMessageVC!
    
    var dataStore: DataStore!
    
    let databaseManager: DatabaseManager = DatabaseManager()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, DisplayData>!
    
    var count = 1
    
    var shouldIncrease: Bool = false
    
    var openMessageVC: OpenMessageVC!
    
    var didSetNotificationDictionary: [Date : Bool]!
        
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
        }
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        setupDataSource()
        setupView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setupDataSource()
    }

    
    // MARK: - Functions
    
    func setupView() {
        self.view.backgroundColor = UIColor(named: "whiteBackgroundColour")
        
        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.05).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 65).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: view.frame.height * 0.15).isActive = true
        
        
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let width = view.frame.width * 0.25
        let height = width * 0.5
        self.view.addSubview(addMessageButton)
        addMessageButton.backgroundColor = .systemBlue
        addMessageButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -view.frame.height * 0.05).isActive = true
        addMessageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -view.frame.width * 0.05).isActive = true
        addMessageButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        addMessageButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        addMessageButton.layer.cornerRadius = cornerRadius()
        
    }
    
    private func getNotificationsArray() {
        let data = databaseManager.getDataToDisplay()
        self.didSetNotificationDictionary = [Date: Bool]()
        for data in data {
            self.didSetNotificationDictionary = [data.dateToShow: false]
        }
    }
    // MARK: - should notify
    func setupNotifications() {
        getNotificationsArray()
        let data = databaseManager.getDataToDisplay()
        var counter = 0
        for (date, shouldNotify) in self.didSetNotificationDictionary {
            if !shouldNotify {
                let content = UNMutableNotificationContent()
                content.title = data[counter].title
                let identifier = UUID().uuidString
                let date = date
                let calendar = Calendar.current
                let dateInfo = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }else{
                        print("send!!")
                    }
                }
                self.didSetNotificationDictionary[date] = false
            }
            counter += 1
        }
    }
    
    func updateCollectionView(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DisplayData>()
        let data = databaseManager.getDataToDisplay()
        snapshot.appendSections([.message])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: - button tapped
    @objc func handleAddTapped() {
        vc = TitleVC()
        let titleVC = UINavigationController(rootViewController: vc)
        titleVC.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        vc.delegate = self
        vc.dataStore = self.dataStore
        vc.shouldAnimate = true
        vc.shouldAnimateTitle = true
        self.present(titleVC, animated: true)
    }
    
}

extension ListOfLettersVC: TitleVCDelegate {
    func deletePhotosPath(_ title: String) {
        databaseManager.deletePhotos(for: title)
    }
    
    func updateData(_ title: String, _ mainData: TimeCapsuleMessage) {
        databaseManager.updateMainData(title, mainData)
    }
    
    func insertDisplayData(_ data: DisplayData) {
        databaseManager.insertDisplayData(data)
        updateCollectionView(animated: true)
    }
    
    func deleteData(_ title: String) {
        databaseManager.deleteData(where: title)
    }
    
    func insertMainData(_ data: TimeCapsuleMessage) {
        databaseManager.insertMainData(data)
    }
    
}

extension ListOfLettersVC {
    func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: date)
        return dateString
        
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource <Section, DisplayData>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, message: DisplayData) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let dateString = self.convertDate(date: message.dateToShow)
            cell.dateToShowLabel.text = dateString
            cell.titleLabel.text = message.title
            let currentDate = Date()
            if currentDate >= message.dateToShow {
                cell.image = true
            } else {
                cell.image = false
            }
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DisplayData>()
        let data = databaseManager.getDataToDisplay()
        snapshot.appendSections([.message])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        
    }
}

extension ListOfLettersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width-15, height: view.frame.height * 0.12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension ListOfLettersVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentTime = Date()
        let data = databaseManager.getDataToDisplay()
        let title = data[indexPath.row].title
        let timeToShow = databaseManager.getTimeToShow(for: title)
        
        if currentTime >= timeToShow {
            print("ya")
            openMessageVC = OpenMessageVC()
            openMessageVC.titleText = title
            openMessageVC.databaseManager = databaseManager
            openMessageVC.dataStore = dataStore
            
            self.navigationController?.pushViewController(openMessageVC, animated: true)
        } else {
            print("nah")
        }
        
    }
    
}

// MARK: - notification center delegate
extension ListOfLettersVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound])
    }
    
}
