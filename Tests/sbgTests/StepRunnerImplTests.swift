//
// Created by Karolina Samorek on 26/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class StepRunnerImplTests: QuickSpec {

    override func spec() {

        var sut: StepRunner!
        var fileRenderer: MockFileRenderer!
        var stringRenderer: MockStringRenderer!
        var directoryAdder: MockDirectoryAdder!
        var fileAdder: MockFileAdder!
        var projectManipulator: MockProjectManipulator!
        var xcodeprojFileNameProvider: MockXcodeprojFileNameProvider!
        var pathProvider: MockSBGPathProvider!

        describe("StepRunnerImpl") {
            var step: Step!
            var parameters: [String: String]!

            beforeEach {
                fileRenderer = MockFileRenderer()
                stringRenderer = MockStringRenderer()
                directoryAdder = MockDirectoryAdder()
                fileAdder = MockFileAdder()
                projectManipulator = MockProjectManipulator()
                xcodeprojFileNameProvider = MockXcodeprojFileNameProvider()
                pathProvider = MockSBGPathProvider()

                sut = StepRunnerImpl(
                    fileRenderer: fileRenderer,
                    stringRenderer: stringRenderer,
                    fileAdder: fileAdder,
                    directoryAdder: directoryAdder,
                    projectManipulator: projectManipulator,
                    xcodeprojFileNameProvider: xcodeprojFileNameProvider,
                    pathProvider: pathProvider
                )

                step = Step(
                    template: MockConstants.template,
                    fileName: MockConstants.filename,
                    group: MockConstants.group,
                    target: MockConstants.target
                )
                parameters = [:]
                fileRenderer.valueToReturn = MockConstants.fileRendererReturnedString
                stringRenderer.valueToReturn = MockConstants.stringRendererReturnedString
                xcodeprojFileNameProvider.fileNameToReturn = MockConstants.xcodeprojFileNameProviderReturnedString
                pathProvider.templatePathToReturn = MockConstants.templatePath
            }

            context("when everything goes well") {

                beforeEach {
                    try! sut.run(step: step, parameters: parameters)
                }

                context("invokes file renderer"){

                    it("exactly once") {
                        expect(fileRenderer.invocationCount).to(equal(1))
                    }

                    it("with name equal path returned by path provider") {
                        expect(fileRenderer.name).to(equal(pathProvider.templatePathToReturn))
                    }
                }

                context("invokes string renderer") {

                    it("three times") {
                        expect(stringRenderer.invocationCount).to(equal(3))
                    }

                    it("with correct strings") {
                        let expectedStrings = [
                            MockConstants.filename,
                            MockConstants.group,
                            MockConstants.target
                        ]
                        expect(stringRenderer.stringArray).to(equal(expectedStrings))
                    }

                    it("with correct contexts") {
                        let expectedContextArray: [[String: String]] = [
                            [:],
                            [:],
                            [:]
                        ]
                        expect(stringRenderer.contextArray).to(equal(expectedContextArray))
                    }
                }

                context("invokes xcodeproj file name provider") {

                    it("exactly once") {
                        expect(xcodeprojFileNameProvider.invocationCount).to(equal(1))
                    }
                }

                context("invokes file adder") {

                    it("exactly once") {
                        expect(fileAdder.invocationCount).to(equal(1))
                    }

                    it("with correct name") {
                        expect(fileAdder.names).to(equal([MockConstants.stringRendererReturnedString]))
                    }

                    it("with content equal to string returned by file renderer") {
                        expect(fileAdder.contentsArray).to(equal([fileRenderer.valueToReturn]))
                    }

                    it("with directory equal to value returned by string renderer") {
                        expect(fileAdder.directories).to(equal([MockConstants.stringRendererReturnedString]))
                    }
                }

                context("invokes project manipulator") {
                    it("exactly once") {
                        expect(projectManipulator.invocationCount).to(equal(1))
                    }

                    it("with groupPath equal to value returned by string renderer") {
                        expect(projectManipulator.groupPath).to(equal(MockConstants.stringRendererReturnedString))
                    }

                    it("with fileName equal to value returned by string renderer") {
                        expect(projectManipulator.fileName).to(equal(MockConstants.stringRendererReturnedString))
                    }

                    it("with xcodeprojFilename to equal value returned by xcodeproj file name provider") {
                        expect(projectManipulator.xcodeprojFile)
                            .to(equal(MockConstants.xcodeprojFileNameProviderReturnedString))
                    }

                    it("with target equal to value returned by string renderer") {
                        expect(projectManipulator.targetName).to(equal(MockConstants.stringRendererReturnedString))
                    }
                }
            }

            context("and file renderer throws error") {
                beforeEach {
                    fileRenderer.renderingError = MockError()
                }

                it("throws expected error") {
                    expect {
                        try sut.run(step: step, parameters: parameters)
                    }.to(throwError(MockError()))
                }
            }

            context("and string renderer throws error") {
                beforeEach {
                    stringRenderer.errorToThrow = MockError()
                }

                it("throws expected error") {
                    expect {
                        try sut.run(step: step, parameters: parameters)
                    }.to(throwError(MockError()))
                }
            }

            context("and xcodeproj file name provider throws error") {
                beforeEach {
                    xcodeprojFileNameProvider.errorToThrow = MockError()
                }

                it("throws expected error") {
                    expect {
                        try sut.run(step: step, parameters: parameters)
                    }.to(throwError(MockError()))
                }
            }

            context("and file adder throws error") {
                beforeEach {
                    fileAdder.errorToThrow = MockError()
                }

                it("throws expected error") {
                    expect {
                        try sut.run(step: step, parameters: parameters)
                    }.to(throwError(MockError()))
                }
            }

            context("and project manipulator throws error") {
                beforeEach {
                    projectManipulator.errorToThrow = MockError()
                }

                it("throws expected error") {
                    expect {
                        try sut.run(step: step, parameters: parameters)
                    }.to(throwError(MockError()))
                }
            }
        }
    }
}

private class MockConstants {
    static let template = "template"
    static let filename = "fileName"
    static let group = "group"
    static let target = "target"

    static let fileRendererReturnedString = "some string"
    static let stringRendererReturnedString = "some string"
    static let xcodeprojFileNameProviderReturnedString = "xcodeproj name"
    static let templatePath = "templatePath"
}