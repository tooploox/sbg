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
    var returnedValue: Result<Void, DirectoryAdderError>!

    func addDirectory(at path: String) -> Result<Void, DirectoryAdderError> {
        invocationCount += 1
        
        self.path = path
        
        return returnedValue
    }
}
