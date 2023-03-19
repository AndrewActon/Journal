//
//  Entry.swift
//  Journal
//
//  Created by Andrew Acton on 3/16/23.
//

import Foundation
import CloudKit

struct EntryConstants {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timeStampKey = "timestamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}//End Of Class

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.titleKey] as? String,
        let body = ckRecord[EntryConstants.bodyKey] as? String,
        let timestamp = ckRecord[EntryConstants.timeStampKey] as? Date
        else { return nil }
        
        self.init(title: title, body: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}//End Of Extension

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordTypeKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.body, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timeStampKey)
    }
}//End of Extension
