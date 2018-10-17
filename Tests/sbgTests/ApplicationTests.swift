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
                fileAdder.returnedValue = .success(())
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
                        generatorParameters: [
                            Application.Constants.Keys.connectorDirectoryPath: MockConstants.connectorDirectory,
                            Application.Constants.Keys.target: MockConstants.target
                        ]
                    )
                }

                it("returns missingFlowName error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.missingFlowName))
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

                it("returns missingConnectorDirectoryPath error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.missingConnectorDirectoryPath))
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

                it("returns missingTargetName error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.missingTargetName))
                }
            }
            
            context("when rendering functions throws an error") {
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
                
                it("returns couldNotRenderFile error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.couldNotRenderFile))
                }
            }
            
            context("when adding file function returns an error") {
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
                    
                    fileAdder.returnedValue = .failure(.writingFailed(MockConstants.fileAdderPath))
                }
                
                it("returns couldNotAddFile error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.couldNotAddFile))
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
                
                it("returns missingTemplate error") {
                    expect(sut.run(parameters: parameters).error).to(equal(ApplicationError.missingTemplate))
                }
            }

            context("when parameters are correct") {

                var result: Result<Void, ApplicationError>!

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

                    result = sut.run(parameters: parameters)
                }

                it("returns success") {
                    expect(result.value).to(beVoid())
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

private class MockFileAdder: FileAdder {

    private(set) var name: String!
    private(set) var content: String!
    private(set) var directory: String!
    private(set) var invocationCount = 0
    
    var returnedValue: Result<Void, FileAdderError>!

    func addFile(with name: String, content: String, to directory: String) -> Result<Void, FileAdderError> {
        self.name = name
        self.content = content
        self.directory = directory
        invocationCount += 1

        return returnedValue
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

private class MockError: Error {}
