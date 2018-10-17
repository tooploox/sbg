//
// Created by Karol on 08/10/2018.
//

import Foundation

enum ApplicationError: Error {
    case wrongGeneratorName(String)
    case missingFlowName
    case missingConnectorDirectoryPath
    case missingTargetName
    case missingTemplate
    case couldNotRenderFile
    case couldNotAddFile
}

extension ApplicationError: Equatable {}
