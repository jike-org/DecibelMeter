//
//  Persist.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 25.05.22.
//


import Foundation
import CoreData
import UIKit

public class Persist {
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: Temporary
    let player = Player()
    var path: URL!
    var id: UUID!
    
    func saveAudio(info: RecordInfo) {
        let context = container.newBackgroundContext()
        
        rename("newRecording", info.id.uuidString)
        
        let newRecording    = Record(context: context)
        
        newRecording.id     = info.id
        newRecording.name   = info.name
        newRecording.length = info.length
        newRecording.date   = info.date
        newRecording.avg    = Int16(info.avg)
        newRecording.min    = Int16(info.min)
        newRecording.max    = Int16(info.max)
        
        do {
            try context.save()
        } catch {
        }
    }
    
    public func fetch() -> [Record]? {
        do {
            let response = try viewContext.fetch(Record.fetchRequest())
            return response
        } catch {
        }
        
        return nil
    }
    
    private func rename(_ initialName: String, _ resultName: String) {
        let fileManager      = FileManager.default
        guard let path       = filePath(for: initialName) else { return }
        guard let resultPath = filePath(for: resultName) else { return }
        
        do {
            try fileManager.moveItem(at: path, to: resultPath)
        } catch {
        }
    }
    
    public func filePath(for key: String) -> URL? {
        let fileManager = FileManager.default
        
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".m4a")
    }
    
}

