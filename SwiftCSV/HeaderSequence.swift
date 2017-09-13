//
//  HeaderSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

struct HeaderGenerator: IteratorProtocol {
    typealias Element = String
    
    fileprivate var fields: [String]
    
    init(text: String, delimiter: CharacterSet) {
        let header = text.lines[0]
        fields = header.components(separatedBy: delimiter)
    }
    
    mutating func next() -> String? {
        return fields.isEmpty ? .none : fields.remove(at: 0)
    }
}

struct HeaderSequence: Sequence {
    typealias Iterator = HeaderGenerator
    
    fileprivate let text: String
    let delimiter: CharacterSet
    
    init(text: String, delimiter: CharacterSet) {
        self.text = text
        self.delimiter = delimiter
    }
    
    func makeIterator() -> HeaderGenerator {
        return HeaderGenerator(text: text, delimiter: delimiter)
    }
}
