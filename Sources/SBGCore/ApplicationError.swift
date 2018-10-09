//
// Created by Karol on 08/10/2018.
//

import Foundation

enum ApplicationError: Error {
    case wrongGeneratorName(String)
    case missingFlowName
}

extension ApplicationError: Equatable {
    public static func ==(lhs: ApplicationError, rhs: ApplicationError) -> Bool {
        switch (lhs, rhs) {
        case (.wrongGeneratorName(let lName), .wrongGeneratorName(let rName)):
            return lName == rName
        case (.missingFlowName, .missingFlowName):
            return true
        default:
            return false
        }
    }
}