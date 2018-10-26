//
// Created by Karol on 2018-10-26.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class GeneratorRunnerTests: QuickSpec {

    override func spec() {
        describe("GeneratorRunner") {

            var sut: GeneratorRunner!
            var stepRunner: MockStepRunner!

            beforeEach {
                stepRunner = MockStepRunner()
                sut = GeneratorRunner(stepRunner: stepRunner)
            }

            context("when generator contains one step") {
                beforeEach {
                    let generator = MockConstants.generator(withNumberOfSteps: 1)
                    try! sut.run(generator: generator, parameters: [:])
                }

                it("invokes stepRunner once") {
                    expect(stepRunner.invocationCount).to(equal(1))
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