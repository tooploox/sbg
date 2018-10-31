//
//  MockFileAdder.swift
//  SBGTests
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
@testable import SBGCore

class MockFileAdder: FileAdder {
    
    private(set) var names = [String]()
    private(set) var contentsArray = [String]()
    private(set) var directories = [String]()
    private(set) var invocationCount = 0

    var errorToThrow: Error?
    
    func addFile(with name: String, content: String, to directory: String) throws {
        names.append(name)
        contentsArray.append(content)
        directories.append(directory)
        invocationCount += 1
        
        if let error = errorToThrow {
            throw error
        }
    }
}
