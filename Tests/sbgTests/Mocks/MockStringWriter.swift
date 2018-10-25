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
    
    var returnedValue: Result<Void, StringWriterError>!
    
    func write(string: String, to filePath: String) -> Result<Void, StringWriterError> {
        self.string = string
        self.filePath = filePath
        self.invocationCount += 1
        return returnedValue
    }
}
