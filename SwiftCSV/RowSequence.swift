//
//  RowSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

struct RowGenerator: IteratorProtocol {
    typealias Element = String
    
    fileprivate var rows: [String]
    
    init(text: String) {
        rows = text.lines
        rows.remove(at: 0)
    }
    
    mutating func next() -> String? {
        return rows.isEmpty ? .none : rows.remove(at: 0)
    }
}

struct RowSequence: Sequence {
    typealias Iterator = RowGenerator
    
    fileprivate let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func makeIterator() -> RowGenerator {
        return RowGenerator(text: text)
    }
}
