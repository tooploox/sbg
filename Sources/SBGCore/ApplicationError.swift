//
// Created by Karol on 08/10/2018.
//

import Foundation

enum ApplicationError: Error {
    case wrongGeneratorName(String)
    case missingFlowName
    case missingConnectorDirectoryPath
    case missingTargetName
}

extension ApplicationError: Equatable {
    public static func ==(lhs: ApplicationError, rhs: ApplicationError) -> Bool {
        switch (lhs, rhs) {
        case (.wrongGeneratorName(let lName), .wrongGeneratorName(let rName)):
            return lName == rName
        case (.missingFlowName, .missingFlowName):
            return true
        case (.missingConnectorDirectoryPath, .missingConnectorDirectoryPath):
            return true
        case (.missingTargetName, .missingTargetName):
            return true
        default:
            return false
        }
    }
}