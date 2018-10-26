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

                it("throws wrongGeneratorName error") {
                    let expectedError = ApplicationError.wrongGeneratorName(MockConstants.wrongName)
                    expect { try sut.run(parameters: parameters) }.to(throwError(expectedError))
                }
            }

            context("when flow_name parameter is missing") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory,
                            Application.Constants.Keys.target: MockConstants.target
                        ]
                    )
                }

                it("throws missingFlowName error") {
                    expect { try sut.run(parameters: parameters) }.to(throwError(ApplicationError.missingFlowName))
                }
            }

            context("when connector directory path parameter is missing") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.moduleName: MockConstants.flowName,
                            Application.Constants.Keys.target: MockConstants.target
                        ]
                    )
                }

                it("throws missingConnectorDirectoryPath error") {
                    let expectedError = ApplicationError.missingConnectorDirectoryPath
                    expect { try sut.run(parameters: parameters) }.to(throwError(expectedError))
                }
            }

            context("when target parameter is missing") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.moduleName: MockConstants.flowName,
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory
                        ]
                    )
                }

                it("throws missingTargetName error") {
                    expect { try sut.run(parameters: parameters) }.to(throwError(ApplicationError.missingTargetName))
                }
            }
            
            context("when rendering fails") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.moduleName: MockConstants.modulerName,
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory,
                            Application.Constants.Keys.target: MockConstants.target,
                            Application.Constants.connectorTemplatePath: MockConstants.connectorTemplatePath
                        ]
                    )
                    
                    fileRenderer.renderingError = MockError()
                }
                
                it("throws error from renderer error") {
                    expect { try sut.run(parameters: parameters) }.to(throwError(MockError()))
                }
            }
            
            context("when adding file fails") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.moduleName: MockConstants.modulerName,
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory,
                            Application.Constants.Keys.target: MockConstants.target,
                            Application.Constants.connectorTemplatePath: MockConstants.connectorTemplatePath
                        ]
                    )
                    
                    fileAdder.errorToThrow = MockError()
                }
                
                it("throws couldNotAddFile error") {
                    expect { try sut.run(parameters: parameters) }.to(throwError(MockError()))
                }
            }
            
            context("when connector template path is missing") {
                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.moduleName: MockConstants.modulerName,
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory,
                            Application.Constants.Keys.target: MockConstants.target
                        ]
                    )
                    
                    fileRenderer.renderingError = MockError()
                }
                
                it("throws missingTemplate error") {
                    expect { try sut.run(parameters: parameters) }.to(throwError(ApplicationError.missingTemplate))
                }
            }

            context("when parameters are correct") {

                beforeEach {
                    parameters = ApplicationParameters(
                        generatorName: MockConstants.correctName,
                        generatorParameters: [
                            Application.Constants.Keys.moduleName: MockConstants.flowName,
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory,
                            Application.Constants.Keys.target: MockConstants.target,
                            Application.Constants.connectorTemplatePath: MockConstants.connectorTemplatePath
                        ]
                    )

                    try! sut.run(parameters: parameters)
                }

                context("invokes file renderer"){

                    it("exactly once") {
                        expect(fileRenderer.invocationCount).to(equal(1))
                    }

                    it("name equal to MockConstants.connectorTemplatePath") {
                        expect(fileRenderer.name).to(equal(MockConstants.connectorTemplatePath))
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

                    it("with groupPath equal to MockConstants.connectorDirectory") {
                        expect(projectManipulator.groupPath).to(equal(MockConstants.connectorDirectory))
                    }

                    it("with fileName equal to MockConstants.connectorName") {
                        expect(projectManipulator.fileName).to(equal(MockConstants.connectorName))
                    }

                    it("with fileName equal to MockConstants.connectorName") {
                        expect(projectManipulator.fileName).to(equal(MockConstants.connectorName))
                    }

                    it("with target equal to MockConstants.target") {
                        expect(projectManipulator.targetName).to(equal(MockConstants.target))
                    }
                }
            }
        }
    }
}

private struct MockConstants {
    static let correctName = Application.Constants.generatorName
    static let wrongName = "wrongName"
    static let flowName = "sampleName"
    static let modulerName = "sampleName"

    static let connectorTemplatePath = "connector_template_path"
    static let connectorDirectory = "connector_directory"
    static let connectorName = MockConstants.flowName + "Connector"

    static let target = "Target"

    static let fileRendererReturnedValue = "Lorem ipsum..."

    static let fileAdderPath = MockConstants.connectorDirectory + "/" + MockConstants.connectorName
}

private class MockFileRenderer: FileRenderer {

    private(set) var name: String!
    private(set) var invocationCount = 0

    var renderingError: Error?
    var returnedValue: String!

    func renderTemplate(name: String, context: [String : Any]?) throws -> String {
        self.name = name
        invocationCount += 1
        
        if let error = renderingError {
            throw error
        }
        
        return returnedValue
    }
}

private class MockProjectManipulator: ProjectManipulator {

    private(set) var groupPath: String!
    private(set) var fileName: String!
    private(set) var xcodeprojFile: String!
    private(set) var targetName: String!

    private(set) var invocationCount = 0

    var errorToThrow: Error?

    func addFileToXCodeProject(groupPath: String, fileName: String, xcodeprojFile: String, target targetName: String) throws {
        self.groupPath = groupPath
        self.fileName = fileName
        self.xcodeprojFile = xcodeprojFile
        self.targetName = targetName
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}
