//
//  EntryError.swift
//  Journal
//
//  Created by Andrew Acton on 3/16/23.
//

import Foundation

enum EntryError: LocalizedError {
    case failedToSaveRecord
    case failedToFetchRecords
    
    var errorDescription: String? {
        switch self {
        case .failedToSaveRecord:
            return "Failed to Save Record"
        case .failedToFetchRecords:
            return "Failed to fetch records"
        }
    }
}
