//
// Created by Karol on 05/10/2018.
//

import Foundation

protocol FileRenderer {
    func renderTemplate(name: String, context: [String: Any]?) throws -> String
}

protocol FileAdder {
    func addFile(with name: String, content: String, to directory: String)
}

protocol ProjectManipulator {
    func addToXCodeProject(file: String, target: String)
}

class Application {

    private let fileRenderer: FileRenderer
    private let fileAdder: FileAdder
    private let projectManipulator: ProjectManipulator

    init(fileRenderer: FileRenderer, fileAdder: FileAdder, projectManipulator: ProjectManipulator) {
        self.fileRenderer = fileRenderer
        self.fileAdder = fileAdder
        self.projectManipulator = projectManipulator
    }

    func run(parameters: ApplicationParameters) -> Result<Void, ApplicationError> {
        guard parameters.generatorName == "cleanui" else {
            return .failure(.wrongGeneratorName(parameters.generatorName))
        }

        guard let flowName = parameters.generatorParameters["flow_name"] else {
            return .failure(.missingFlowName)
        }

        guard let connectorFile = try? fileRenderer.renderTemplate(name: flowName, context: parameters.generatorParameters) else {
            return .failure(.couldNotRenderFile)
        }
        
        fileAdder.addFile(with: flowName + "Connector", content: connectorFile, to: parameters.generatorParameters["connector_directory"]!)
        projectManipulator.addToXCodeProject(file: connectorFile, target: parameters.generatorParameters["target"]!)

        return .success(())
    }
}
