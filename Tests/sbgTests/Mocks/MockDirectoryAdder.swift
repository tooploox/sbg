//
//  MockDirectoryAdder.swift
//  SBGTests
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
@testable import SBGCore

class MockDirectoryAdder: DirectoryAdder {
    
    private(set) var path: String!
    private(set) var invocationCount = 0

    var errorToThrow: Error?

    func addDirectory(at path: String) throws {
        invocationCount += 1
        self.path = path

        if let error = errorToThrow {
            throw error
        }
    }
}
