//
// Created by Karol on 05/10/2018.
//

import Foundation

struct ApplicationParameters {
    let generatorName: String
    let generatorParameters: [String: String]
}

protocol FileRenderer {
    func render(from template: String, parameters: [String: String]) -> String
}

protocol FileAdder {
    func addFile(with name: String, content: String, to directory: String)
}

protocol ProjectManipulator {
    func addToXCodeProject(file: String, target: String)
}

enum ApplicationError: Error {
    case wrongGeneratorName(String)
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

        let file = fileRenderer.render(from: "path_to_template", parameters: parameters.generatorParameters)
        fileAdder.addFile(with: "someName", content: file, to: parameters.generatorParameters["directory"]!)
        projectManipulator.addToXCodeProject(file: file, target: parameters.generatorParameters["target"]!)

        return .success(())
    }
}
