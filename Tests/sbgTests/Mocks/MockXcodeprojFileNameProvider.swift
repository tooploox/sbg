//
// Created by Karolina Samorek on 26/10/2018.
//

import Foundation
@testable import SBGCore

class MockXcodeprojFileNameProvider: XcodeprojFileNameProvider {

    var fileNameToReturn: String!
    var errorToThrow: Error?

    private(set) var invocationCount = 0

    func getXcodeprojFileName() throws -> String {
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }

        return fileNameToReturn
    }
}