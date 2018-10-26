//
// Created by Karol on 2018-10-26.
//

import Foundation

final class StepRunnerImpl: StepRunner {

    private let fileRenderer: FileRenderer
    private let stringRenderer: StringRenderer
    private let fileAdder: FileAdder
    private let projectManipulator: ProjectManipulator
    private let xcodeprojFileNameProvider: XcodeprojFileNameProvider

    init(fileRenderer: FileRenderer, stringRenderer: StringRenderer, fileAdder: FileAdder, projectManipulator: ProjectManipulator, xcodeprojFileNameProvider: XcodeprojFileNameProvider) {
        self.fileRenderer = fileRenderer
        self.stringRenderer = stringRenderer
        self.fileAdder = fileAdder
        self.projectManipulator = projectManipulator
        self.xcodeprojFileNameProvider = xcodeprojFileNameProvider
    }

    func run(step: Step, parameters: [String: String]) throws {
        let fileContent = try fileRenderer.renderTemplate(name: step.template, context: parameters)
        let fileName = try stringRenderer.render(string: step.fileName, context: parameters)
        let groupPath = try stringRenderer.render(string: step.group, context: parameters)
        let xcodeprojFileName = try xcodeprojFileNameProvider.getXcodeprojFileName()

        try fileAdder.addFile(with: fileName, content: fileContent, to: groupPath)
        try projectManipulator.addFileToXCodeProject(
            groupPath: groupPath,
            fileName: fileName,
            xcodeprojFile: xcodeprojFileName,
            target: step.target
        )
    }
}