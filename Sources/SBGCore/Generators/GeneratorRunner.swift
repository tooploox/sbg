//
// Created by Karol on 2018-10-26.
//

import Foundation

protocol StringRenderer {
    func render(string: String, context: [String: String]) throws -> String
}

protocol XcodeprojFileNameProvider {
    func getXcodeprojFileName() throws -> String
}

protocol StepRunner {
    func run(step: Step, parameters: [String: String]) throws
}

enum GeneratorRunnerError: Error {
    case noStepsDefined
}

final class GeneratorRunner {

    private let stepRunner: StepRunner

    init(stepRunner: StepRunner) {
        self.stepRunner = stepRunner
    }

    func run(generator: Generator, parameters: [String: String]) throws {
        guard !generator.steps.isEmpty else {
            throw GeneratorRunnerError.noStepsDefined
        }

        for step in generator.steps {
            try stepRunner.run(step: step, parameters: parameters)
        }
    }
}