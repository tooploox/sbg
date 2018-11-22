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

extension ProjectManipulatorError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .cannotFindRootGroup:
                return "The root group could not be found"
            case .cannotFindGroup(let groupName):
                return "Group \(groupName) cound not be found"
            case .cannotFindTarget(let targetName):
                return "Target \(targetName) could not be found"
            case .cannotGetSourcesBuildPhase:
                return "Build phase could not be obtained"
            case .fileAlreadyExists(let fileName):
                return "File \(fileName) already exists"
        }
    }
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

    private let fileRenderer: FileRenderer
    private let stringRenderer: StringRenderer
    private let fileAdder: FileAdder
    private let directoryAdder: DirectoryAdder
    private let projectManipulator: ProjectManipulator
    private let xcodeprojFileNameProvider: XcodeprojFileNameProvider
    private let pathProvider: SBGPathProvider

    init(fileRenderer: FileRenderer, stringRenderer: StringRenderer, fileAdder: FileAdder, directoryAdder: DirectoryAdder, projectManipulator: ProjectManipulator, xcodeprojFileNameProvider: XcodeprojFileNameProvider, pathProvider: SBGPathProvider) {
        self.fileRenderer = fileRenderer
        self.stringRenderer = stringRenderer
        self.fileAdder = fileAdder
        self.directoryAdder = directoryAdder
        self.projectManipulator = projectManipulator
        self.xcodeprojFileNameProvider = xcodeprojFileNameProvider
        self.pathProvider = pathProvider
    }

    func run(step: Step, parameters: [String: String]) throws {
        let fileContent = try fileRenderer.renderTemplate(
            name: pathProvider.templatePath(forTemplate: step.template),
            context: parameters
        )
        let fileName = try stringRenderer.render(string: step.fileName, context: parameters)
        let groupPath = try stringRenderer.render(string: step.group, context: parameters)
        let target = try stringRenderer.render(string: step.target, context: parameters)
        let xcodeprojFileName = try xcodeprojFileNameProvider.getXcodeprojFileName()

        try directoryAdder.addDirectory(at: groupPath)
        try fileAdder.addFile(with: fileName, content: fileContent, to: groupPath)
        try projectManipulator.addFileToXCodeProject(
            groupPath: groupPath,
            fileName: fileName,
            xcodeprojFile: xcodeprojFileName,
            target: target
        )
    }
}