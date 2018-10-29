//
//  MockFileAdder.swift
//  SBGTests
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
@testable import SBGCore

class MockFileAdder: FileAdder {
    
    private(set) var name: String!
    private(set) var content: String!
    private(set) var directory: String!
    private(set) var invocationCount = 0

    var errorToThrow: Error?
    
    func addFile(with name: String, content: String, to directory: String) throws {
        self.name = name
        self.content = content
        self.directory = directory
        invocationCount += 1
        
        if let error = errorToThrow {
            throw error
        }
    }
}
