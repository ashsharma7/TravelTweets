//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

open class CSV {
    static fileprivate let comma = CharacterSet(charactersIn: ",")
    
    open fileprivate(set) var header: [String] = []
    open fileprivate(set) var rows: [[String: String]] = []
    open fileprivate(set) var columns: [String: [String]] = [:]
    
    public init(string: String, delimiter: CharacterSet = comma) {
        let headerSequence = HeaderSequence(text: string, delimiter: delimiter)
        for fieldName in headerSequence {
            header.append(fieldName)
            columns[fieldName] = []
        }
        
        for row in RowSequence(text: string) {
            var fields: [String: String] = [:]
            autoreleasepool {
                for (fieldIndex, field) in FieldSequence(text: row, headerSequence: headerSequence).enumerated() {
                    let fieldName = header[fieldIndex]
                    fields[fieldName] = field
                    columns[fieldName]?.append(field)
                }
            }
            rows.append(fields)
        }
    }
    
    public convenience init(name: String, delimiter: CharacterSet = comma, encoding: String.Encoding = String.Encoding.utf8) throws {
        var contents: String!
        do {
            //let startTime = CFAbsoluteTimeGetCurrent()
            contents = try String(contentsOfFile: name, encoding: encoding)
            //let endTime = CFAbsoluteTimeGetCurrent()
            //print("reading String took ",endTime - startTime)
        } catch {
            throw error
        }
        
        self.init(string: contents, delimiter: delimiter)
    }
    
    public convenience init(url: URL, delimiter: CharacterSet = comma, encoding: String.Encoding = String.Encoding.utf8) throws {
        var contents: String!
        do {
            contents = try String(contentsOf: url, encoding: encoding)
        } catch {
            throw error
        }
        
        self.init(string: contents, delimiter: delimiter)
    }
    
    open func dataUsingEncoding(_ encoding: String.Encoding) -> Data? {
        return description.data(using: encoding)
    }
}

extension CSV: CustomStringConvertible {
    public var description: String {
        var contents = header.joined(separator: ",")
        
        for row in rows {
            contents += "\n"
            
            let fields = header.map { row[$0]! }
            contents += fields.joined(separator: ",")
        }
        
        return contents
    }
}
