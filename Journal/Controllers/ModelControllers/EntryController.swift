//
//  EntryController.swift
//  Journal
//
//  Created by Andrew Acton on 3/16/23.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    //Shared Instance
    static let shared = EntryController()
    //Source Of Truth
    var entries: [Entry] = []
    
    
    //MARK: - CRUD
    
    func createEntryWith(title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let entry = Entry(title: title, body: body, timestamp: Date())
        save(entry: entry) { result in
        }
    }
    
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let newEntry = CKRecord(entry: entry)
        
        CKContainer.default().privateCloudDatabase.save(newEntry) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(.failure(.failedToSaveRecord))
            }
            
            guard let records = records,
                  let entry = Entry.init(ckRecord: records)
            else { return completion(.failure(.failedToSaveRecord)) }
            
            self.entries.append(entry)
            print(self.entries)
        }
        
    
    }
    
    func fetchEntriesWith(completion: @escaping(_ result: Result<[Entry]?, EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(.failure(.failedToFetchRecords))
            }
            
            let fetchedEntries = records?.compactMap { Entry(ckRecord: $0) }
            self.entries = fetchedEntries!
        }
    }
    
}//End Of Class
