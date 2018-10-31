//
//  MockDirectoryAdder.swift
//  SBGTests
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
@testable import SBGCore

class MockDirectoryAdder: DirectoryAdder {
    
    private(set) var paths = [String]()
    private(set) var invocationCount = 0

    var errorsToThrow = [Error]()

    func addDirectory(at path: String) throws {
        invocationCount += 1
        paths.append(path)

        if let error = errorsToThrow[safe: invocationCount-1] {
            throw error
        }
    }
}