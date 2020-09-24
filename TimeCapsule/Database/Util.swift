//
//  Util.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-12.
//

import Foundation
import UIKit

class Util: NSObject {
    
    //where the data base is set to
    class func getPath(_ fileName: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        print("Database Path :- \(fileUrl.path)")
        return fileUrl.path
    }
    
    // copys the data base from documents directory into its own when using it
    class func copyDatabase(_ fileName: String) {
        let dbPath = getPath("TimeCapsule.db")
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: dbPath) {
            let bundle = Bundle.main.resourceURL
            let file = bundle?.appendingPathComponent(fileName)
            var error:NSError?
            do {
                try fileManager.copyItem(atPath: (file?.path)!, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            if error == nil {
                print("Successfully connected to database")
            } else {
                print(error ?? "error")
            }
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}

extension UIColor {
    
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
    
    static func offWhite() -> UIColor {
        return rgb(red: 225, green: 225, blue: 223, alpha: 1)
    }
    
    static func offWhite2() -> UIColor {
        return rgb(red: 220, green: 220, blue: 215, alpha: 1)
    }
    
}


// MARK: - Custom textfield to add additional padding and icons
public class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 2, left: 0, bottom: 5, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //sets an an img at the left side of the textfield
    func setIcon(_ image: UIImage?) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 2.5, width: 24, height: 24))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
}

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}
extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
            case .LINE_POSITION_TOP:
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
                break
            case .LINE_POSITION_BOTTOM:
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
                break
        }
    }
}

struct screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let minusNumber = width * 0.1207
}

extension UIViewController {
    func cornerRadius() -> CGFloat {
        if screen.height == 812 || screen.height <= 667  {
            return 22
        } else if screen.height >= 736 {
            return 25
        } else {
            return 15
        }
    }
    
    
    
    func cellSize() -> CGSize {
        if screen.height <= 667  {
            return CGSize(width: 80, height: 80)
        } else if screen.height >= 736 || screen.height == 812 {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    
    func viewHeight() -> CGFloat {
        if screen.height <= 667  {
            return 90
        } else if screen.height >= 736 || screen.height == 812 {
            return 110
        } else {
            return 90
        }
    }
}

extension UICollectionViewCell {
    func cornerRadius() -> CGFloat {
        if screen.height == 812 || screen.height <= 667  {
            return 22
        } else if screen.height >= 736 {
            return 25
        } else {
            return 15
        }
    }
}

// MARK: - clear navigation bar 
struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
