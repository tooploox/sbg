//
// Created by Karol on 2018-10-26.
//

import Foundation

protocol StepRunner {
    func run(step: Step, parameters: [String: String]) throws
}

enum GeneratorRunnerError: Error {
    case noStepsDefined
}

extension GeneratorRunnerError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noStepsDefined:
                return "Generator does not have any steps"
        }
    }
}

final class GeneratorRunnerImpl: GeneratorRunner {

    private let stepRunner: StepRunner

    init(stepRunner: StepRunner) {
        self.stepRunner = stepRunner
    }

    func run(generator: Generator, parameters: [String: String]) throws {
        guard !generator.steps.isEmpty else {
            throw GeneratorRunnerError.noStepsDefined
        }

        try generator.steps.enumerated().forEach { index, step in
            try stepRunner.run(step: step, parameters: parameters)

            print("Succesfully finished \(index + 1) out of \(generator.steps.count) steps.")
        }
    }
}
