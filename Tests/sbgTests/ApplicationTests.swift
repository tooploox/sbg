//
// Created by Karol on 05/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class ApplicationTests: QuickSpec {

    override func spec() {
        describe("Application") {

            var sut: Application!
            var fileRenderer: MockFileRenderer!
            var fileAdder: MockFileAdder!
            var projectManipulator: MockProjectManipulator!
            var parameters: ApplicationParameters!

            beforeEach {
                fileRenderer = MockFileRenderer()
                fileAdder = MockFileAdder()
                projectManipulator = MockProjectManipulator()
                sut = Application(
                    fileRenderer: fileRenderer,
                    fileAdder: fileAdder,
                    projectManipulator: projectManipulator
                )

                fileRenderer.returnedValue = MockConstants.fileRendererReturnedValue
            }

            context("when generatorName is wrong") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.wrongName,
                        generatorParameters: [:]
                    )
                }

                it("returns wrongGeneratorName error") {
                    expect(sut.run(parameters: parameters).error)
                        .to(equal(ApplicationError.wrongGeneratorName(MockConstants.wrongName)))
                }
            }

            context("when flow_name parameter is missing") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [:]
                    )
                }

                it("returns missingFlowName error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.missingFlowName))
                }
            }

            context("when parameters are correct") {

                var result: Result<Void, ApplicationError>!

                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            "flow_name": MockConstants.flowName,
                            "connector_directory": MockConstants.connectorDirectory,
                            "target": MockConstants.target
                        ]
                    )

                    result = sut.run(parameters: parameters)
                }

                it("returns success") {
                    expect(result.value).to(beVoid())
                }

                context("invokes file renderer"){

                    it("exactly once") {
                        expect(fileRenderer.invocationCount).to(equal(1))
                    }

                    it("with template equal to MockConstants.connectorTemplatePath") {
                        expect(fileRenderer.template).to(equal(MockConstants.connectorTemplatePath))
                    }

                    it("name equal to MockConstants.flowName") {
                        expect(fileRenderer.name).to(equal(MockConstants.flowName))
                    }
                }

                context("invokes file adder") {
                    it("exactly once") {
                        expect(fileAdder.invocationCount).to(equal(1))
                    }

                    it("with name equal to MockConstants.connectorName") {
                        expect(fileAdder.name).to(equal(MockConstants.connectorName))
                    }

                    it("with content equal to MockConstants.fileRendererReturnedValue") {
                        expect(fileAdder.content).to(equal(MockConstants.fileRendererReturnedValue))
                    }

                    it("with directory equal to MockConstants.connectorDirectory") {
                        expect(fileAdder.directory).to(equal(MockConstants.connectorDirectory))
                    }
                }

                context("invokes project manipulator") {
                    it("exactly once") {
                        expect(projectManipulator.invocationCount).to(equal(1))
                    }

                    it("with file equal to MockConstants.fileRendererReturnedValue") {
                        expect(projectManipulator.file).to(equal(MockConstants.fileRendererReturnedValue))
                    }

                    it("with target equal to MockConstants.target") {
                        expect(projectManipulator.target).to(equal(MockConstants.target))
                    }
                }
            }
        }
    }
}

private struct MockConstants {
    static let correctName = "cleanui"
    static let wrongName = "wrongName"
    static let flowName = "sampleName"

    static let connectorTemplatePath = "connector_template_path"
    static let connectorDirectory = "connector_directory"
    static let connectorName = MockConstants.flowName + "Connector"

    static let target = "Target"

    static let fileRendererReturnedValue = "Lorem ipsum..."
}

private class MockFileRenderer: FileRenderer {

    private(set) var template: String!
    private(set) var name: String!
    private(set) var invocationCount = 0

    var returnedValue: String!

    func render(from template: String, name: String) -> String {
        self.template = template
        self.name = name
        invocationCount += 1
        return returnedValue
    }
}

private class MockFileAdder: FileAdder {

    private(set) var name: String!
    private(set) var content: String!
    private(set) var directory: String!
    private(set) var invocationCount = 0

    func addFile(with name: String, content: String, to directory: String) {
        self.name = name
        self.content = content
        self.directory = directory
        invocationCount += 1
    }
}

private class MockProjectManipulator: ProjectManipulator {

    private(set) var file: String!
    private(set) var target: String!
    private(set) var invocationCount = 0

    func addToXCodeProject(file: String, target: String) {
        self.file = file
        self.target = target
        invocationCount += 1
    }
}
