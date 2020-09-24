//
//  AddMessageVC.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-13.
//

import UIKit
import AVFoundation

protocol AddMessageDelegate {
    func updateData(_ title: String,_ mainData: TimeCapsuleMessage)
    func deleteData(_ title: String)
    func insertDisplayData(_ data: DisplayData)
    func deletePhotosFolder(_ uuid: String, title: String)
    func deletePhotosPath(_ title: String)
}

class AddMessageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 35)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a date: "
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont(name: "Arial", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photosLabel: UILabel = {
        let label = UILabel()
        label.text = "Add photos"
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont(name: "Arial", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var audioLabel: UILabel = {
        let label = UILabel()
        label.text = "Record a message"
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont(name: "Arial", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectDateBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageTextField: UITextView = {
        let textField = UITextView()
        textField.delegate = self
        textField.text = "Send yourself a message..."
        textField.layer.masksToBounds = false
        textField.textColor = .lightGray
        textField.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        textField.font = UIFont(name: "Arial", size: 16)
        textField.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cV.delegate = self
        layout.scrollDirection = .horizontal
        cV.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        cV.translatesAutoresizingMaskIntoConstraints = false
        return cV
    }()
    
    var photosCollectionViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "secondaryBackgroundColour")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addPhotosButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addPhotosTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var audioCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cV.delegate = self
        layout.scrollDirection = .horizontal
        cV.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        cV.translatesAutoresizingMaskIntoConstraints = false
        return cV
    }()
    
    var audioCollectionViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "secondaryBackgroundColour")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addVoiceRecordingsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addVoiceRecordingTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let photosEditButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(editPhotosButtonTapped), for: .touchUpInside)
        button.setTitle("edit", for: .normal)
        let attributedTitle = NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let photosDeleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deletePhotosButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let audioEditButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(editAudioButtonTapped), for: .touchUpInside)
        button.setTitle("edit", for: .normal)
        let attributedTitle = NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let audioDeleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteAudioButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    
    private var audioDataSource: UICollectionViewDiffableDataSource<Section, AVAudioFile>!
    
    var titleText: String = ""
    
    var delegate: AddMessageDelegate?
    
    var dataStore = DataStore()
    
    var message: TimeCapsuleMessage!
    
    var imageView = UIImageView()
    
    let databaseManager = DatabaseManager()
    
    var uuid: String = ""
    
    var shouldDelete = true
    
    var imgs: [UIImage]!
    
    var playImgs: [AVAudioFile]!
    
    var datePicker: UIDatePicker!
    
    var recordingSession: AVAudioSession!
    
    var audioRecorder: AVAudioRecorder!
    
    var audioPLayer: AVAudioPlayer!
    
    var numberOfRecords = 0
    
    var photos: [String: Bool]!
    
    var audioFiles: [String: Bool]!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photosCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        self.audioCollectionView.register(AudioCell.self, forCellWithReuseIdentifier: AudioCell.identifier)
        
        self.imgs = [UIImage]()
        self.photos = [String: Bool]()
        self.playImgs = [AVAudioFile]()
        self.audioFiles = [String: Bool]()
        
        setupPhotosDataSource()
        setupAudioDataSource()
        
        setupView()
        
        titleLabel.text = titleText
        hideKeyboardWhenTappedAround()
        
        notificationCenter.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uuid = databaseManager.getUUID(titleText)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)  
        if shouldDelete {
            reset()
            delegate?.deleteData(titleText)
            delegate?.deletePhotosFolder(uuid, title: titleText)
            delegate?.deletePhotosPath(titleText)
            audioPLayer = nil
        }
    }
    
    // MARK: - Functions
    func setupView() {
        
        view.backgroundColor = UIColor(named: "whiteBackgroundColour")
        
        self.view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.05).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(selectDateBackground)
        selectDateBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectDateBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectDateBackground.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        selectDateBackground.heightAnchor.constraint(equalToConstant: viewHeight() * 0.5).isActive = true
        
        datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = UIColor(named: "whiteBackgroundColour")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        self.selectDateBackground.addSubview(datePicker)
        datePicker.backgroundColor = UIColor(named: "secondaryWhiteBackgroundColour")
        datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        if screen.height <= 667 {
            datePicker.centerXAnchor.constraint(equalTo: selectDateBackground.centerXAnchor, constant: 12).isActive = true
        } else {
            datePicker.centerXAnchor.constraint(equalTo: selectDateBackground.centerXAnchor, constant: 10).isActive = true
        }
        
        
        self.selectDateBackground.addSubview(selectDateLabel)
        selectDateLabel.centerYAnchor.constraint(equalTo: selectDateBackground.centerYAnchor).isActive = true
        selectDateLabel.leftAnchor.constraint(equalTo: selectDateBackground.leftAnchor, constant: 5).isActive = true
        
        self.view.addSubview(messageTextField)
        messageTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        messageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageTextField.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: selectDateBackground.topAnchor, constant: -22).isActive = true
        messageTextField.layer.shadowColor = UIColor.black.cgColor
        messageTextField.layer.shadowOpacity = 0.3
        messageTextField.layer.shadowOffset = .zero
        
        var height = view.frame.height * 0.2
        
        self.view.addSubview(photosCollectionViewBackground)
        photosCollectionViewBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photosCollectionViewBackground.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        photosCollectionViewBackground.topAnchor.constraint(equalTo: selectDateBackground.bottomAnchor, constant: 22).isActive = true
        photosCollectionViewBackground.heightAnchor.constraint(equalToConstant: viewHeight()).isActive = true
        
        self.photosCollectionViewBackground.addSubview(addPhotosButton)
        addPhotosButton.centerYAnchor.constraint(equalTo: photosCollectionViewBackground.centerYAnchor).isActive = true
        addPhotosButton.rightAnchor.constraint(equalTo: photosCollectionViewBackground.rightAnchor, constant: -12).isActive = true
        
        self.photosCollectionViewBackground.addSubview(photosCollectionView)
        photosCollectionView.topAnchor.constraint(equalTo: photosCollectionViewBackground.topAnchor).isActive = true
        photosCollectionView.bottomAnchor.constraint(equalTo: photosCollectionViewBackground.bottomAnchor).isActive = true
        photosCollectionView.rightAnchor.constraint(equalTo: addPhotosButton.leftAnchor, constant: -8).isActive = true
        photosCollectionView.leftAnchor.constraint(equalTo: photosCollectionViewBackground.leftAnchor).isActive = true
        
        let width = view.frame.width * 0.25
        height = width * 0.5
        
        self.view.addSubview(audioCollectionViewBackground)
        audioCollectionViewBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        audioCollectionViewBackground.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        audioCollectionViewBackground.topAnchor.constraint(equalTo: photosCollectionViewBackground.bottomAnchor, constant: 12).isActive = true
        audioCollectionViewBackground.heightAnchor.constraint(equalToConstant: viewHeight()).isActive = true
        
        self.audioCollectionViewBackground.addSubview(addVoiceRecordingsButton)
        addVoiceRecordingsButton.centerYAnchor.constraint(equalTo: audioCollectionViewBackground.centerYAnchor).isActive = true
        addVoiceRecordingsButton.centerXAnchor.constraint(equalTo: addPhotosButton.centerXAnchor).isActive = true
        
        self.audioCollectionViewBackground.addSubview(audioCollectionView)
        audioCollectionView.topAnchor.constraint(equalTo: audioCollectionViewBackground.topAnchor).isActive = true
        audioCollectionView.bottomAnchor.constraint(equalTo: audioCollectionViewBackground.bottomAnchor).isActive = true
        audioCollectionView.rightAnchor.constraint(equalTo: photosCollectionView.rightAnchor).isActive = true
        audioCollectionView.leftAnchor.constraint(equalTo: audioCollectionViewBackground.leftAnchor).isActive = true
        
        self.view.addSubview(doneButton)
        doneButton.backgroundColor = .systemGreen
        if screen.height <= 667 {
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.03).isActive = true
        } else {
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.05).isActive = true
        }
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.frame.width * 0.05).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        doneButton.alpha = 0
        
        self.photosCollectionViewBackground.addSubview(photosLabel)
        photosLabel.centerYAnchor.constraint(equalTo: photosCollectionViewBackground.centerYAnchor).isActive = true
        photosLabel.centerXAnchor.constraint(equalTo: photosCollectionViewBackground.centerXAnchor).isActive = true
        
        self.audioCollectionViewBackground.addSubview(audioLabel)
        audioLabel.centerYAnchor.constraint(equalTo: audioCollectionViewBackground.centerYAnchor).isActive = true
        audioLabel.centerXAnchor.constraint(equalTo: audioCollectionViewBackground.centerXAnchor).isActive = true
        
        self.photosCollectionViewBackground.addSubview(photosEditButton)
        photosEditButton.topAnchor.constraint(equalTo: photosCollectionViewBackground.topAnchor, constant: 2).isActive = true
        photosEditButton.centerXAnchor.constraint(equalTo: addPhotosButton.centerXAnchor).isActive = true
        photosEditButton.alpha = 0
        
        self.view.addSubview(photosDeleteButton)
        photosDeleteButton.bottomAnchor.constraint(equalTo: photosCollectionViewBackground.bottomAnchor, constant: -4).isActive = true
        photosDeleteButton.centerXAnchor.constraint(equalTo: addPhotosButton.centerXAnchor).isActive = true
        photosDeleteButton.alpha = 0
        
        self.audioCollectionViewBackground.addSubview(audioEditButton)
        audioEditButton.topAnchor.constraint(equalTo: audioCollectionViewBackground.topAnchor, constant: 2).isActive = true
        audioEditButton.centerXAnchor.constraint(equalTo: addVoiceRecordingsButton.centerXAnchor).isActive = true
        audioEditButton.alpha = 0
        
        self.audioCollectionViewBackground.addSubview(audioDeleteButton)
        audioDeleteButton.bottomAnchor.constraint(equalTo: audioCollectionViewBackground.bottomAnchor, constant: -4).isActive = true
        audioDeleteButton.centerXAnchor.constraint(equalTo: addVoiceRecordingsButton.centerXAnchor).isActive = true
        audioDeleteButton.alpha = 0
        
        messageTextField.layer.cornerRadius = cornerRadius()
        doneButton.layer.cornerRadius = cornerRadius()
        photosCollectionView.layer.cornerRadius = cornerRadius()
        photosCollectionViewBackground.layer.cornerRadius = cornerRadius()
        audioCollectionView.layer.cornerRadius = cornerRadius()
        audioCollectionViewBackground.layer.cornerRadius = cornerRadius()
        selectDateBackground.layer.cornerRadius = cornerRadius()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        photosCollectionView.allowsMultipleSelection = editing
        let indexPaths = photosCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = photosCollectionView.cellForItem(at: indexPath) as! ImageCell
            cell.isInEditingMode = editing
        }
        audioCollectionView.allowsMultipleSelection = editing
        let indexPathsAudio = audioCollectionView.indexPathsForVisibleItems
        for indexPath in indexPathsAudio {
            let cell = audioCollectionView.cellForItem(at: indexPath) as! AudioCell
            cell.isInEditingMode = editing
        }
    }
    
    // MARK: - edit action
    @objc func editPhotosButtonTapped() {
        if photosEditButton.title(for: .normal) == "edit" {
            isEditing = true
            photosEditButton.setTitle("done", for: .normal)
            photosEditButton.setAttributedTitle(NSMutableAttributedString(string: "done", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            photosDeleteButton.alpha = 1
            photosDeleteButton.isEnabled = false
            addPhotosButton.alpha = 0
        } else {
            photosEditButton.setTitle("edit", for: .normal)
            photosEditButton.setAttributedTitle(NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            photosDeleteButton.alpha = 0
            addPhotosButton.alpha = 1
            let paths = databaseManager.getPhotoNames(forTitle: titleText)
            self.imgs = dataStore.getImageFromDocumentDirectory(paths: paths)
            updatePhotosCollectionView(animated: true, a: self.imgs)
            photos.removeAll()

            isEditing = false
        }
    }
    
    @objc func editAudioButtonTapped() {
        if audioEditButton.title(for: .normal) == "edit" {
            isEditing = true
            audioEditButton.setTitle("done", for: .normal)
            audioEditButton.setAttributedTitle(NSMutableAttributedString(string: "done", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            audioDeleteButton.alpha = 1
            audioDeleteButton.isEnabled = false
            addVoiceRecordingsButton.alpha = 0
        } else {
            audioEditButton.setTitle("edit", for: .normal)
            audioEditButton.setAttributedTitle(NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            audioDeleteButton.alpha = 0
            addVoiceRecordingsButton.alpha = 1
            let paths = databaseManager.getAudioNames(forTitle: titleText)
            self.playImgs = dataStore.getAudiosFromDocumentDirectory(paths: paths)
            updateAudioCollectionView(animated: true, a: self.playImgs)
            audioFiles.removeAll()

            isEditing = false
        }
    }
    
    @objc func deletePhotosButtonTapped() {
        
        for (photoURL, shouldDelete) in photos  {
            if shouldDelete {
                let url = dataStore.imageURL(forKey: photoURL)
                dataStore.deleteImage(url: url, title: titleText)
                databaseManager.deletePhotoPaths(name: photoURL)
            }
        }
        let paths = databaseManager.getPhotoNames(forTitle: titleText)
        self.imgs = dataStore.getImageFromDocumentDirectory(paths: paths)
        if self.imgs.count > 0 {
            UIView.animate(withDuration: 0.8) {
                self.photosEditButton.setTitle("edit", for: .normal)
                self.photosEditButton.setAttributedTitle(NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            }
        } else {
            UIView.animate(withDuration: 0.8) {
                self.photosLabel.alpha = 1
                self.photosEditButton.alpha = 0
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.photosDeleteButton.alpha = 0
        }
        self.photosDeleteButton.isEnabled = false

        photos.removeAll()
        isEditing = false
        addPhotosButton.alpha = 1

        updatePhotosCollectionView(animated: true, a: self.imgs)
        
    }
    @objc func deleteAudioButtonTapped() {
        for (audioURL, shouldDelete) in audioFiles {
            if shouldDelete {
                let url = dataStore.imageURL(forKey: audioURL)
                dataStore.deleteAudio(title: audioURL)
                databaseManager.deleteAudioPaths(name: url)
            }
        }
        let paths = databaseManager.getAudioNames(forTitle: titleText)
        self.playImgs = dataStore.getAudiosFromDocumentDirectory(paths: paths)
        if self.playImgs.count > 0 {
            UIView.animate(withDuration: 0.8) {
                self.audioEditButton.setTitle("edit", for: .normal)
                self.audioEditButton.setAttributedTitle(NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            }
        } else {
            UIView.animate(withDuration: 0.8) {
                self.audioEditButton.alpha = 0
                self.audioLabel.alpha = 1
            }
            
        }
        UIView.animate(withDuration: 0.3) {
            self.audioDeleteButton.alpha = 0
        }
        audioDeleteButton.isEnabled = false
        audioFiles.removeAll()
        isEditing = false
        addVoiceRecordingsButton.alpha = 1

        updateAudioCollectionView(animated: true, a: self.playImgs)
    }
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    func customDateTitle() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .long
        let dateString = formatter.string(from: currentDate)
        return dateString
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let dateString = customDateTitle()
        let titleString = titleText + dateString
        let mystring = titleString.replacingOccurrences(of: " ", with: "")
        let myString2 = mystring.replacingOccurrences(of: ":", with: "")
        databaseManager.insertPhotoNames(messageTitle: titleText, photoName: myString2)
        //dataStore.setImage(image, forKey: uuid, title: myString2)
        print(dataStore.saveImageToDocumentDirectory(image, photoName: myString2))
        self.imgs.append(image)
        self.photos = [myString2: false]
        updatePhotosCollectionView(animated: true, a: self.imgs)
        dismiss(animated: true)
    }
    
    // MARK: - add photos/ voice recordings
    @objc func addPhotosTapped() {
        let imagepicker = imagePicker(for:UIImagePickerController.SourceType.photoLibrary)
        self.present(imagepicker, animated: true, completion: nil)
    }
    
    @objc func addVoiceRecordingTapped() {
        if audioRecorder == nil {
            var fileName: String?
            numberOfRecords += 1
            let dateString = customDateTitle()
            let titleString = titleText + dateString
            let mystring = titleString.replacingOccurrences(of: " ", with: "")
            let myString2 = mystring.replacingOccurrences(of: ":", with: "")
            fileName = dataStore.audioURL(myString2)
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do {
                audioRecorder = try AVAudioRecorder(url: URL(string: fileName!)!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                databaseManager.insertAudioNames(messageTitle: titleText, audioName: myString2)
                addVoiceRecordingsButton.setImage(UIImage(systemName: "stop"), for: .normal)
                playImgs.append(dataStore.getAudioFromDocumentDirectory(path: myString2))
            } catch {
                print(error.localizedDescription)
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil
            addVoiceRecordingsButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
        updateAudioCollectionView(animated: true, a: self.playImgs)
    }
    
    func updatePhotosCollectionView(animated: Bool, a: [UIImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.photos])
        snapshot.appendItems(a)
        if imgs.count > 0 {
            photosLabel.alpha = 0
            photosEditButton.alpha = 1
            photosEditButton.setAttributedTitle(NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
            
        }
        
        photoDataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func updateAudioCollectionView(animated: Bool, a: [AVAudioFile]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AVAudioFile>()
        snapshot.appendSections([.audioRecording])
        snapshot.appendItems(playImgs)
        if playImgs.count != 0 {
            audioEditButton.alpha = 1
            audioLabel.alpha = 0
            audioEditButton.setAttributedTitle(NSMutableAttributedString(string: "edit", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
        }
        audioDataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func reset() {
        self.messageTextField.text = ""
        self.titleLabel.text = ""
        self.doneButton.alpha = 0
    }
    
    // MARK: - Done button tapped
    @objc func doneButtonTapped() {
        if messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let data = DisplayData(title: titleText, dateToShow: datePicker.date)
            let mainData = TimeCapsuleMessage(message: messageTextField.text, title: nil, dateRecorded: nil, dateToShow: datePicker.date)
            delegate?.insertDisplayData(data)
            delegate?.updateData(titleText, mainData)
            setupNotifications()
            shouldDelete = false
            self.dismiss(animated: true) {
                self.reset()
            }
        } else {
            shouldDelete = true
            self.dismiss(animated: true) {
                self.reset()
            }
        }
    }
    
    func setupNotifications() {
        let content = UNMutableNotificationContent()
        content.title = titleText
        let identifier = UUID().uuidString
        let date = datePicker.date
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
    }
}

extension AddMessageVC: TitleVCDelegateForTitle {
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
}

extension AddMessageVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == messageTextField {
            if textView.text == "Send yourself a message..." {
                textView.textColor = .label
                textView.text = ""
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == messageTextField {
            if messageTextField.text != "" {
                UIView.animate(withDuration: 0.8) {
                    self.doneButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.8) {
                    self.doneButton.alpha = 0
                    textView.textColor = .lightGray
                    textView.text = "Send yourself a message..."
                }
            }
        }
    }
}


extension AddMessageVC {
    func setupPhotosDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource <Section, UIImage>(collectionView: photosCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, photos: UIImage) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.isInEditingMode = self.isEditing
            
            if self.imgs.count == 0 {
                cell.image = nil
                return cell
            }
            cell.image = photos
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        let array = [UIImage]()
        snapshot.appendSections([.photos])
        snapshot.appendItems(array)
        photoDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupAudioDataSource() {
        audioDataSource = UICollectionViewDiffableDataSource <Section, AVAudioFile>(collectionView: audioCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, audioFile: AVAudioFile) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioCell.identifier, for: indexPath) as! AudioCell
            cell.isInEditingMode = self.isEditing
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AVAudioFile>()
        let array = [AVAudioFile]()
        snapshot.appendSections([.audioRecording])
        snapshot.appendItems(array)
        audioDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension AddMessageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension AddMessageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let fileName = databaseManager.getAudioNames(forTitle: titleText)
        if collectionView == audioCollectionView {
            if !isEditing {
                audioDeleteButton.isEnabled = false
                do {
                    audioPLayer = try AVAudioPlayer(contentsOf: URL(string:fileName[indexPath.row])!)
                    audioPLayer.play()
                } catch {
                }
            } else {
                let names = databaseManager.getAudioNames(forTitle: titleText)
                audioDeleteButton.isEnabled = true
                audioFiles[names[indexPath.row]] = true
            }
            
        } else if collectionView == photosCollectionView {
            if !isEditing {
                photosDeleteButton.isEnabled = false
            } else {
                let names = databaseManager.getPhotoNames(forTitle: titleText)
                photosDeleteButton.isEnabled = true
                self.photos[names[indexPath.row]] = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == audioCollectionView {
            let names = databaseManager.getAudioNames(forTitle: titleText)
            if names.count > 0 {
                audioFiles[names[indexPath.row]] = false
                
                if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
                    audioDeleteButton.isEnabled = false
                    collectionView.cellForItem(at: indexPath)?.isSelected = false
                }
            }
        } else if collectionView == photosCollectionView {
            let names = databaseManager.getPhotoNames(forTitle: titleText)
            if names.count > 0 {
                photos[names[indexPath.row]] = false
                
                if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
                    photosDeleteButton.isEnabled = false
                    collectionView.cellForItem(at: indexPath)?.isSelected = false
                }
            }
        }
    }
}



extension AddMessageVC: AVAudioRecorderDelegate {
    
}

extension AddMessageVC: UNUserNotificationCenterDelegate {
    
}
