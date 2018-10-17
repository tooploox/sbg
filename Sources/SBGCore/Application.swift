//
// Created by Karol on 05/10/2018.
//

import Foundation

public protocol FileRenderer {
    func renderTemplate(name: String, context: [String: Any]?) throws -> String
}

public protocol FileAdder {
    func addFile(with name: String, content: String, to directory: String)
}

public protocol ProjectManipulator {
    func addFileToXCodeProject(groupPath: String, fileName: String, xcodeprojFile: String, target targetName: String) -> Result<Void, ProjectManipulatorError>
}

public enum ProjectManipulatorError: Error {
    case cannotOpenXcodeproj(String)
    case cannotFindRootGroup
    case cannotAddFileToGroup(String, String)
    case cannotFindGroup(String)
    case cannotFindTarget(String)
    case cannotGetSourcesBuildPhase
    case cannotAddFileToSourcesBuildPhase(String)
    case cannotWriteXcodeprojFile
}

public class Application {

    struct Constants {
        static let generatorName = "cleanmodule"
        static let connectorTemplatePath = "connector_template_path"

        struct Keys {
            static let moduleName = "module_name"
            static let connectorDirectoryPath = "connector_directory"
            static let target = "target"
        }
    }

    private let fileRenderer: FileRenderer
    private let fileAdder: FileAdder
    private let projectManipulator: ProjectManipulator

    init(fileRenderer: FileRenderer, fileAdder: FileAdder, projectManipulator: ProjectManipulator) {
        self.fileRenderer = fileRenderer
        self.fileAdder = fileAdder
        self.projectManipulator = projectManipulator
    }

    func run(parameters: ApplicationParameters) -> Result<Void, ApplicationError> {
        guard parameters.generatorName == Constants.generatorName else {
            return .failure(.wrongGeneratorName(parameters.generatorName))
        }

        guard let flowName = parameters.generatorParameters[Constants.Keys.moduleName] else {
            return .failure(.missingFlowName)
        }
        
        guard let connectorDirectoryPath = parameters.generatorParameters[Constants.Keys.connectorDirectoryPath] else {
            return .failure(.missingConnectorDirectoryPath)
        }

        guard let target = parameters.generatorParameters[Constants.Keys.target] else {
            return .failure(.missingTargetName)
        }
        
        guard let template = parameters.generatorParameters[Constants.connectorTemplatePath] else {
            return .failure(.missingTemplate)
        }

        guard let connectorFile = try? fileRenderer.renderTemplate(name: template , context: parameters.generatorParameters) else {
            return .failure(.couldNotRenderFile)
        }
        
        fileAdder.addFile(with: flowName + "Connector", content: connectorFile, to: connectorDirectoryPath)
        projectManipulator.addFileToXCodeProject(
            groupPath: Constants.Keys.connectorDirectoryPath,
            fileName: flowName + "Connector.swift",
            xcodeprojFile: "Some project file",
            target: target
        )
//        projectManipulator.addToXCodeProject(filePath: connectorFile, target: target)

        return .success(())
    }
}
