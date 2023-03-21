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
            switch result {
            case .success(let result):
                guard let entry = result else { return }
                self.entries.append(entry)
                print("Saved entry successfully")
                return completion(.success(entry))
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                print("Failed to save entry")
                return completion(.failure(error))
            }
        }
    }
    
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let newEntry = CKRecord(entry: entry)
        
        privateDB.save(newEntry) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(.failure(.failedToSaveRecord))
            }
            
            guard let records = records,
                  let savedEntry = Entry(ckRecord: records)
            else { return completion(.failure(.failedToSaveRecord)) }
            
            self.entries.append(entry)
            return completion(.success(savedEntry))
        }
        
    
    }
    
    func fetchEntriesWith(completion: @escaping(_ result: Result<[Entry]?, EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(.failure(.failedToFetchRecords))
            }
            
            let fetchedEntries = records?.compactMap { Entry(ckRecord: $0) }
            self.entries = fetchedEntries!
            print(self.entries.count)
            return completion(.success(fetchedEntries))
        }
    }
    
}//End Of Class
