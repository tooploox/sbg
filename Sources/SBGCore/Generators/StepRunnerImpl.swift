//
// Created by Karol on 2018-10-26.
//

import Foundation

enum ProjectManipulatorError: Error {
    case cannotFindRootGroup
    case cannotFindGroup(String)
    case cannotFindTarget(String)
    case cannotGetSourcesBuildPhase
    case fileAlreadyExists(String)
}

protocol StringRenderer {
    func render(string: String, context: [String: String]) throws -> String
}

protocol XcodeprojFileNameProvider {
    func getXcodeprojFileName() throws -> String
}

public protocol FileRenderer {
    func renderTemplate(name: String, context: [String: Any]?) throws -> String
}

protocol FileAdder {
    func addFile(with name: String, content: String, to directory: String) throws
}

public protocol ProjectManipulator {
    func addFileToXCodeProject(groupPath: String, fileName: String, xcodeprojFile: String, target targetName: String) throws
}

final class StepRunnerImpl: StepRunner {

    struct Constants {
        static let templatesPath = ".sbg/templates/"
    }

    private let fileRenderer: FileRenderer
    private let stringRenderer: StringRenderer
    private let fileAdder: FileAdder
    private let directoryAdder: DirectoryAdder
    private let projectManipulator: ProjectManipulator
    private let xcodeprojFileNameProvider: XcodeprojFileNameProvider

    init(fileRenderer: FileRenderer, stringRenderer: StringRenderer, directoryAdder: DirectoryAdder, fileAdder: FileAdder, projectManipulator: ProjectManipulator, xcodeprojFileNameProvider: XcodeprojFileNameProvider) {
        self.fileRenderer = fileRenderer
        self.stringRenderer = stringRenderer
        self.directoryAdder = directoryAdder
        self.fileAdder = fileAdder
        self.projectManipulator = projectManipulator
        self.xcodeprojFileNameProvider = xcodeprojFileNameProvider
    }

    func run(step: Step, parameters: [String: String]) throws {
        let fileContent = try fileRenderer.renderTemplate(name: Constants.templatesPath + step.template, context: parameters)
        let fileName = try stringRenderer.render(string: step.fileName, context: parameters)
        let groupPath = try stringRenderer.render(string: step.group, context: parameters)
        let xcodeprojFileName = try xcodeprojFileNameProvider.getXcodeprojFileName()

        try directoryAdder.addDirectory(at: groupPath)
        try fileAdder.addFile(with: fileName, content: fileContent, to: groupPath)
        try projectManipulator.addFileToXCodeProject(
            groupPath: groupPath,
            fileName: fileName,
            xcodeprojFile: xcodeprojFileName,
            target: step.target
        )
    }
}