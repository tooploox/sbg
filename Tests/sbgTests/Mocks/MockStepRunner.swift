//
// Created by Karol on 2018-10-26.
//

import Foundation
@testable import SBGCore

class MockStepRunner: StepRunner {

    private(set) var step: Step!
    private(set) var parameters: [String: String]!

    private(set) var invocationCount = 0

    var errorToThrow: Error?

    func run(step: Step, parameters: [String: String]) throws {
        self.step = step
        self.parameters = parameters

        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}