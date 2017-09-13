//
//  FieldSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

struct FieldGenerator: IteratorProtocol {
    typealias Element = String
    
    fileprivate var fields: [String]
    fileprivate var headerGenerator: HeaderGenerator
    
    init(text: String, headerSequence: HeaderSequence) {
        fields = text.components(separatedBy: headerSequence.delimiter)
        headerGenerator = headerSequence.makeIterator()
    }
    
    mutating func next() -> String? {
        switch headerGenerator.next() {
        case .some(_):
            return fields.count > 0 ? fields.remove(at: 0) : ""
        case .none:
            return .none
        }
    }
}

struct FieldSequence: Sequence {
    typealias Iterator = FieldGenerator
    
    fileprivate let text: String
    fileprivate let headerSequence: HeaderSequence
    
    init(text: String, headerSequence: HeaderSequence) {
        self.text = text
        self.headerSequence = headerSequence
    }
    
    func makeIterator() -> FieldGenerator {
        return FieldGenerator(text: text, headerSequence: headerSequence)
    }
}
