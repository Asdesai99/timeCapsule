//
//  TitleVC.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-16.
//

import UIKit

protocol TitleVCDelegate {
    func insertMainData(_ data: TimeCapsuleMessage)
    func updateData(_ title: String,_ mainData: TimeCapsuleMessage)
    func insertDisplayData(_ data: DisplayData)
    func deleteData(_ title:String)
    func deletePhotosPath(_ title: String)
}

protocol TitleVCDelegateForTitle {
    func setTitle(_ title: String)
}

class TitleVC: UIViewController {
    
    // MARK: - Properties
    lazy var titleTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Name your message"
        textField.delegate = self
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowOffset = .zero
        textField.layer.cornerRadius = 25
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.setTitle("next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name your message"
        label.font = UIFont(name: "Futura", size: 35)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var delegate: TitleVCDelegate?
    
    var delegateForTitle: TitleVCDelegateForTitle?
    
    var dataStore: DataStore!
    
    var shouldAnimateButton = true
    
    var shouldAnimateTitle = true
    
    var shouldAnimate = true
    
    var addMessageVc: AddMessageVC!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTextField.delegate = self
        setupView()
        shouldAnimate = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Functions
    
    func setupView() {
        view.backgroundColor = UIColor(named: "whiteBackgroundColour")
        self.view.addSubview(titleTextField)
        titleTextField.becomeFirstResponder()

        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleTextField.addLine(position: .LINE_POSITION_BOTTOM, color: .label, width: 1)
        
        let width = view.frame.width * 0.25
        let height = width * 0.5
        self.view.addSubview(nextButton)
        nextButton.backgroundColor = .systemBlue
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.08).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.frame.width * 0.08).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        nextButton.layer.cornerRadius = cornerRadius()

        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.05).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - screen.minusNumber).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.alpha = 0
        titleLabel.frame.origin.y += 300
        nextButton.alpha = 0

    }
    
    func reset() {
        shouldAnimateTitle = true
        shouldAnimateButton = true
        titleTextField.text = ""
        titleTextField.placeholder = "Name Your message"
        
        titleLabel.alpha = 0
        titleLabel.frame.origin.y += 300
        nextButton.alpha = 0
    }
    
    // MARK: - button tapped
    @objc func nextButtonTapped() {
        addMessageVc = AddMessageVC()
        let currentDate = Date()
        let data = TimeCapsuleMessage(message: nil, title: titleTextField.text, dateRecorded: currentDate, dateToShow: nil)
        delegate?.insertMainData(data)
        delegateForTitle?.setTitle(titleTextField.text!)
        addMessageVc.titleText = self.titleTextField.text!
        addMessageVc.delegate = self
        self.delegateForTitle = addMessageVc
        self.shouldAnimateTitle = false
        self.shouldAnimate = false
        self.navigationController?.pushViewController(addMessageVc, animated: true)
    }
}

extension TitleVC: AddMessageDelegate {
    func deletePhotosPath(_ title: String) {
        delegate?.deletePhotosPath(title)
    }
    
    func deletePhotosFolder(_ uuid: String, title: String) {
        dataStore.deleteFolder(forKey: uuid, title: title)
    }
    
    func updateData(_ title: String, _ mainData: TimeCapsuleMessage) { 
        delegate?.updateData(titleTextField.text!, mainData)
    }
    
    func insertDisplayData(_ data: DisplayData) {
        delegate?.insertDisplayData(data)
    }
    
    func deleteData(_ title: String) {
        delegate?.deleteData(title)
    }
    
}

extension TitleVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField && shouldAnimateButton && textField.text != "" {
            UIView.animate(withDuration: 0.8) {
                self.shouldAnimateButton = false
                self.nextButton.alpha = 1
            }
        } else if textField.text == "" {
            textField.placeholder = "Name your message"
            self.shouldAnimateButton = true
            self.nextButton.alpha = 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleTextField && shouldAnimateTitle {
            textField.placeholder = ""
            UIView.animate(withDuration: 0.8) {
                self.shouldAnimateTitle = false
                self.titleLabel.alpha = 1
                self.titleLabel.frame.origin.y -= 300
            }
        }
    }
}
