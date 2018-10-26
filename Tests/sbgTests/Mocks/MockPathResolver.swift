//
//  MockPathResolver.swift
//  SBGTests
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
@testable import SBGCore

class MockPathResolver: PathResolver {
    
    private(set) var directory: String!
    private(set) var name: String!
    private(set) var fileExtension: String!
    
    private(set) var invocationCount = 0
    var returnedValue: String!
    
    func createFinalPath(from directory: String, name: String, fileExtension: String) -> String {
        invocationCount += 1
        
        self.directory = directory
        self.name = name
        self.fileExtension = fileExtension
        
        return returnedValue
    }
}
