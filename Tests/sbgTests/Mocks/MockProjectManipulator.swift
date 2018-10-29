//
// Created by Karolina Samorek on 26/10/2018.
//

import Foundation
@testable import SBGCore

class MockProjectManipulator: ProjectManipulator {

    private(set) var groupPath: String!
    private(set) var fileName: String!
    private(set) var xcodeprojFile: String!
    private(set) var targetName: String!

    private(set) var invocationCount = 0

    var errorToThrow: Error?

    func addFileToXCodeProject(groupPath: String, fileName: String, xcodeprojFile: String, target targetName: String) throws {
        self.groupPath = groupPath
        self.fileName = fileName
        self.xcodeprojFile = xcodeprojFile
        self.targetName = targetName
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}
