//
// Created by Karol on 2018-10-26.
//

import Foundation
@testable import SBGCore

class MockStepRunner: StepRunner {

    private(set) var steps = [Step]()
    private(set) var parametersArray = [[String: String]]()

    private(set) var invocationCount = 0

    var errorToThrow: Error?

    func run(step: Step, parameters: [String: String]) throws {
        steps.append(step)
        parametersArray.append(parameters)

        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}