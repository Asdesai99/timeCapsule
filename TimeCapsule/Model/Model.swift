//
//  Model.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-12.
//

import Foundation
import UIKit
import AVFoundation

struct DisplayData: Hashable {
    let identifier: UUID = UUID()
    var title: String
    var dateToShow: Date
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: DisplayData, rhs: DisplayData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

enum Section {
    case message
    case photos
    case audioRecording
}

struct TimeCapsuleMessage: Hashable {
    let identifier = UUID().uuidString
    let message: String?
    let title: String?
    let dateRecorded: Date?
    let dateToShow: Date?
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: TimeCapsuleMessage, rhs: TimeCapsuleMessage) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class DataStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func getImageFromDocumentDirectory(paths: [String]) -> [UIImage] {
        let fileManager = FileManager.default
        var image = [UIImage]()

        for path in paths {
            let url = imageURL(forKey: path)
            if fileManager.fileExists(atPath: url) {
                image.append((UIImage(contentsOfFile: url)!))
            }
            else {
                print("No Image Found")
            }
        }
        
        return image
    }
    
    
    func getAudiosFromDocumentDirectory(paths: [String]) -> [AVAudioFile] {
        let fileManager = FileManager.default
        var audioFiles = [AVAudioFile]()

        for path in paths {
            let url = audioURL(path)
            if fileManager.fileExists(atPath: url) {
                do {
                    try audioFiles.append(AVAudioFile(forReading: URL(string:url)!))
                } catch {
                    
                }
            }
            else {
                print("No Image Found")
            }
        }
        
        return audioFiles
    }
    
    func getAudioFromDocumentDirectory(path: String) -> AVAudioFile {
        let fileManager = FileManager.default
        var audioFile = AVAudioFile()
            
            if fileManager.fileExists(atPath: path) {
                do {
                    try audioFile = AVAudioFile(forReading: URL(string:path)!)
                } catch {
                    
                }
            }
            else {
                print("No Image Found")
            }
        
        return audioFile
}
    
    
    
    func deleteFolder(forKey key: String, title: String) {
        cache.removeObject(forKey: title as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(atPath: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey photoName: String) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let filepath = directoryPath.appending(photoName).appending(".jpg")
        
        return filepath
    }
    
    func audioURL(_ forkey: String) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let filepath = directoryPath.appending(forkey).appending(".m4a")
        
        return filepath
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage, photoName: String) -> String {
        let filepath = imageURL(forKey: photoName)
        let url = NSURL.fileURL(withPath: filepath)
            do {
                try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
                return String.init("\(filepath)")

            } catch {
                print(error)
                print("file cant not be save at path \(filepath), with error : \(error)");
                return filepath
            }
        }
    

    func deleteImage(url: String, title: String) {
        cache.removeObject(forKey: title as NSString)
        
        do {
            try FileManager.default.removeItem(atPath: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    
    func deleteAudio(title: String) {
            let url = audioURL(title)
        do {
            try FileManager.default.removeItem(atPath: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
}
