//
// Created by Karol on 2018-10-26.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class GeneratorRunnerImplTests: QuickSpec {

    override func spec() {
        describe("GeneratorRunnerImpl") {

            var sut: GeneratorRunner!
            var stepRunner: MockStepRunner!

            beforeEach {
                stepRunner = MockStepRunner()
                sut = GeneratorRunnerImpl(stepRunner: stepRunner)
            }

            context("when generator contains one step") {
                var generator: Generator!
                var parameters: [String: String]!

                beforeEach {
                    generator = MockConstants.generator(withNumberOfSteps: 1)
                    parameters = [:]
                    try! sut.run(generator: generator, parameters: parameters)
                }

                it("invokes stepRunner once") {
                    expect(stepRunner.invocationCount).to(equal(1))
                }

                it("invokes stepRunner with correct step") {
                    expect(stepRunner.steps).to(equal(generator.steps))
                }

                it("invokes stepRunner with correct parameters") {
                    expect(stepRunner.parametersArray.first).to(equal(parameters))
                }
            }

            context("when generator contains more than one steps") {
                var generator: Generator!
                var parameters: [String: String]!

                beforeEach {
                    generator = MockConstants.generator(withNumberOfSteps: 3)
                    parameters = [:]
                    try! sut.run(generator: generator, parameters: parameters)
                }

                it("invokes stepRunner correct number of times") {
                    expect(stepRunner.invocationCount).to(equal(3))
                }

                it("invokes stepRunner with correct step") {
                    expect(stepRunner.steps).to(equal(generator.steps))
                }

                it("invokes stepRunner with correct parameters") {
                    stepRunner.parametersArray.forEach { receivedParameters in
                        expect(receivedParameters).to(equal(parameters))
                    }
                }
            }

            context("when generator contains zero steps") {
                var generator: Generator!
                var parameters: [String: String]!

                beforeEach {
                    generator = MockConstants.generator(withNumberOfSteps: 0)
                    parameters = [:]
                }

                it("throws expected error") {
                    let expectedError = GeneratorRunnerError.noStepsDefined
                    expect {
                        try sut.run(generator: generator, parameters: parameters)
                    }
                    .to(throwError(expectedError))
                }
            }

            context("when stepRunner throws error") {
                var generator: Generator!
                var parameters: [String: String]!

                beforeEach {
                    stepRunner.errorToThrow = MockError()
                    generator = MockConstants.generator(withNumberOfSteps: 3)
                    parameters = [:]
                }

                it("throws expected error") {
                    expect {
                        try sut.run(generator: generator, parameters: parameters)
                    }
                    .to(throwError(MockError()))
                }
            }
        }
    }
}

private class MockConstants {
    static let generatorName = "generatorName"
    static let template = "template"
    static let filename = "fileName"
    static let group = "group"
    static let target = "target"

    static func generator(withNumberOfSteps numberOfSteps: Int) -> Generator {
        let steps = Array(0..<numberOfSteps).map {
            Step(
                template: MockConstants.template + String($0),
                fileName: MockConstants.filename + String($0),
                group: MockConstants.group + String($0),
                target: MockConstants.target + String($0)
            )
        }

        return Generator(name: MockConstants.generatorName, steps: steps)
    }
}