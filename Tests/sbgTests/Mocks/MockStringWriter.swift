//
//  MockStringWriter.swift
//  SBGTests
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
@testable import SBGCore

class MockStringWriter: StringWriter {
    
    private(set) var string: String!
    private(set) var filePath: String!
    private(set) var invocationCount = 0
    
    var errorToThrow: Error?
    
    func write(string: String, to filePath: String) throws {
        self.string = string
        self.filePath = filePath
        self.invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}
