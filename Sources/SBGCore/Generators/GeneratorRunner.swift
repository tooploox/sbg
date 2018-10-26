//
// Created by Karol on 2018-10-26.
//

import Foundation
import Stencil

class StringRenderer {
    func render(string: String, context: [String: String]) throws -> String {
        return try Environment().renderTemplate(string: string, context: context)
    }
}

class XcodeprojFileNameProvider {
    func getXcodeprojFileName() throws -> String {
        return try FileManager.default
            .contentsOfDirectory(atPath: ".")
            .filter { (s: String) -> Bool in s.hasSuffix(".xcodeproj") }
            .first!
    }
}


class GeneratorRunner {

    let fileRenderer: FileRenderer
    let stringRenderer: StringRenderer
    let fileAdder: FileAdder
    let projectManipulator: ProjectManipulator
    let xcodeprojFileNameProvider: XcodeprojFileNameProvider

    init(fileRenderer: FileRenderer, stringRenderer: StringRenderer, fileAdder: FileAdder, projectManipulator: ProjectManipulator, xcodeprojFileNameProvider: XcodeprojFileNameProvider) {
        self.fileRenderer = fileRenderer
        self.stringRenderer = stringRenderer
        self.fileAdder = fileAdder
        self.projectManipulator = projectManipulator
        self.xcodeprojFileNameProvider = xcodeprojFileNameProvider
    }

    func run(generator: Generator, parameters: [String: String]) throws {

        for step in generator.steps {
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
}