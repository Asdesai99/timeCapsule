//
//  DatabaseManager.swift
//  TimeCapsule
//
//  Created by Akash Desai on 2020-07-12.
//

import Foundation

class DatabaseManager: NSObject {
    
    var database:FMDatabase = FMDatabase(path: Util.getPath("TimeCapsule.db"))
    
    func insertDisplayData(_ displayData: DisplayData) -> Bool {
        database.open()
        let insertQuery = "INSERT INTO 'Display_data' (title, date_to_show) VALUES (?,?)"
        let didSave = database.executeUpdate(insertQuery, withArgumentsIn: [displayData.title, displayData.dateToShow])
        database.close()
        
        return didSave
        
    }
    
    func getDataToDisplay() -> [DisplayData] {
        database.open()
        var data = [DisplayData]()
        let getQuery = "SELECT * FROM 'Display_data'"
        do {
            let result:FMResultSet! = try database.executeQuery(getQuery, values: nil)
            while result.next() {
                let title = result.string(forColumn: "title")
                let dateToShow = result.date(forColumn: "date_to_show")
                data.append(DisplayData(title: title ?? "a", dateToShow: dateToShow ?? Date()))
            }
            database.close()
            return data
        } catch {
            
        }
        database.close()
        return data
    }
    
    func insertMainData(_ mainData: TimeCapsuleMessage) {
        database.open()
        
        let insertQuery = "INSERT INTO 'Main' (title, message, date_recorded, date_to_show, UUID) VALUES (?,?,?,?,?)"
        do {
            try database.executeUpdate(insertQuery, values: [mainData.title, mainData.message, mainData.dateRecorded, mainData.dateToShow, mainData.identifier])
        } catch {
            
        }
        
        database.close()
    }
    
    func updateMainData(_ title: String, _ mainData: TimeCapsuleMessage) {
        let uuid = self.getUUID(title)
        database.close()
        database.open()
        
        let insertQuery = "UPDATE Main SET message = ?, date_to_show = ? WHERE UUID = '\(uuid)'"
        do {
            try database.executeUpdate(insertQuery, values: [mainData.message, mainData.dateToShow])
        } catch {
            
        }
        
        database.close()
    }
    
    func getMessage(for title: String) -> String {
        database.open()
        var timeCapsuleMessage: String!
        let getMainDataQuery = "SELECT * FROM Main WHERE title = '\(title)'"
        do {
            let result:FMResultSet! = try database.executeQuery(getMainDataQuery, values: nil)
            while result.next() {
                timeCapsuleMessage = result.string(forColumn: "message")
            }
        } catch {
            
        }
        database.close()
        return timeCapsuleMessage
    }
    
    func getTimeToShow(for title: String) -> Date {
        database.open()
        var timeCapsuleMessage: Date!
        let getMainDataQuery = "SELECT * FROM Main WHERE title = '\(title)'"
        do {
            let result:FMResultSet! = try database.executeQuery(getMainDataQuery, values: nil)
            while result.next() {
                timeCapsuleMessage = result.date(forColumn: "date_to_show")
            }
        } catch {
            
        }
        database.close()
        return timeCapsuleMessage
    }
    
    
    
    func getUUID(_ title: String) -> String {
        var uuid: String = ""
        database.open()
        let getUUIDQuery = "SELECT * FROM Main WHERE title = '\(title)'"
        
        do {
            let result:FMResultSet! = try database.executeQuery(getUUIDQuery, values: nil)
            if result.next() {
                return result.string(forColumn: "UUID") ?? ""
            }
        } catch {
            print(error.localizedDescription)
        }
        database.close()
        return uuid
    }
    
    func deleteData(where title: String) {
        let uuid = self.getUUID(title)
        database.close()
        database.open()
        
        let deleteQuery = "DELETE FROM Main WHERE uuid = '\(uuid)'"
        do {
            try database.executeUpdate(deleteQuery, values: nil)
        } catch {
            
        }
    
        database.close()
    }
    
    func insertPhotoNames(messageTitle: String, photoName: String) {
        database.open()
        let insertPhotoNameQuery = "INSERT INTO Photos (title, photo_name) VALUES (?,?)"
        
        do {
            try database.executeUpdate(insertPhotoNameQuery, values: [messageTitle, photoName])
        } catch {
        }
        database.close()
        
    }
    
    func getPhotoNames(forTitle title: String) -> [String] {
        database.open()
        var names = [String]()
        
        let getNamesQuery = "SELECT * FROM Photos WHERE title = '\(title)'"
        
        do {
            let result: FMResultSet! = try database.executeQuery(getNamesQuery, values: nil)
            while result.next() {
                var name = result.string(forColumn: "photo_name") ?? ""
                names.append(name)
            }
            return names

        } catch {
        }
        database.close()
        
        return names

    }
    
    func insertAudioNames(messageTitle: String, audioName: String) {
        database.open()
        let insertAudioNameQuery = "INSERT INTO Audio_recordings (title, audio_path) VALUES (?,?)"
        
        do {
            try database.executeUpdate(insertAudioNameQuery, values: [messageTitle, audioName])
        } catch {
        }
        database.close()
        
    }
    
    func getAudioNames(forTitle title: String) -> [String] {
        database.open()
        var names = [String]()
        
        let getNamesQuery = "SELECT * FROM Audio_recordings WHERE title = '\(title)'"
        
        do {
            let result: FMResultSet! = try database.executeQuery(getNamesQuery, values: nil)
            while result.next() {
                var name = result.string(forColumn: "audio_path") ?? ""
                names.append(name)
            }
            return names

        } catch {
        }
        database.close()
        
        return names

    }
    
    func deletePhotoPaths(name: String) {
        database.open()
            let deleteQuery = "DELETE FROM Photos WHERE photo_name = '\(name)'"
            do {
                try database.executeUpdate(deleteQuery, values: nil)
            } catch {
                
            }
        
        database.close()
    }
    
    
    func deletePhotos(for title: String) {
        database.open()
        let deletePhotosQuery = "DELETE FROM Photos WHERE title = '\(title)'"
        do {
            try database.executeUpdate(deletePhotosQuery, values: nil)
        } catch {
        }
        
        database.close()
    }
    
    func deleteAudioPaths(name: String) {
        database.open()
            let deleteQuery = "DELETE FROM Audio_recordings WHERE audio_path = '\(name)'"
            do {
                try database.executeUpdate(deleteQuery, values: nil)
            } catch {
                
            }
        
        database.close()
    }
    
    func delteAudio(for title: String) {
        database.open()
        let deleteAudioQuery = "DELETE FROM Audio_recordings WHERE title = '\(title)'"
        
        do {
            try database.executeUpdate(deleteAudioQuery, values: nil)
        } catch {
        }
        database.close()
    }
    
    
}
