//
// Created by Karol on 05/10/2018.
//

import Foundation

struct ApplicationParameters {
    let generatorName: String
    let generatorParameters: [String: String]
}

protocol FileRenderer {
    func render(from template: String, name: String) -> String
}

protocol FileAdder {
    func addFile(with name: String, content: String, to directory: String)
}

protocol ProjectManipulator {
    func addToXCodeProject(file: String, target: String)
}

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

        let connectorFile = fileRenderer.render(from: "connector_template_path", name: flowName)
        fileAdder.addFile(with: flowName + "Connector", content: connectorFile, to: parameters.generatorParameters["connector_directory"]!)
        projectManipulator.addToXCodeProject(file: connectorFile, target: parameters.generatorParameters["target"]!)

        return .success(())
    }
}
