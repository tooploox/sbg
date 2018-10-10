//
// Created by Karol on 05/10/2018.
//

import Foundation

protocol FileRenderer {
    func render(from template: String, name: String) -> String
}

protocol FileAdder {
    func addFile(with name: String, content: String, to directory: String)
}

protocol ProjectManipulator {
    func addToXCodeProject(file: String, target: String)
}

class Application {

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

        let connectorFile = fileRenderer.render(from: Constants.connectorTemplatePath, name: flowName)
        fileAdder.addFile(with: flowName + "Connector", content: connectorFile, to: connectorDirectoryPath)
        projectManipulator.addToXCodeProject(file: connectorFile, target: target)

        return .success(())
    }
}
