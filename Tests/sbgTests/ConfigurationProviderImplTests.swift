//
// Created by Karol on 19/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class ConfigurationProviderImplTests: QuickSpec {

    override func spec() {
        describe("ConfigurationProviderImpl") {

            var commandLineConfigProvider: MockCommandLineConfigProvider!
            var fileConfigProvider: MockFileConfigProvider!
            var pathProvider: MockSBGPathProvider!
            var sut: ConfigurationProviderImpl!

            beforeEach {
                commandLineConfigProvider = MockCommandLineConfigProvider()
                fileConfigProvider = MockFileConfigProvider()
                pathProvider = MockSBGPathProvider()
                sut = ConfigurationProviderImpl(
                    commandLineConfigProvider: commandLineConfigProvider,
                    fileConfigProvider: fileConfigProvider,
                    pathProvider: pathProvider
                )
            }

            context("when commandLineAndFile source was specified") {
                context("when commandLineConfigProvider and fileConfigProvider return disjoint sets of params") {

                    beforeEach {
                        commandLineConfigProvider.returnedValue = CommandLineConfiguration(
                            commandName: "commandName",
                            variables: ["param1": "value1"]
                        )
                        fileConfigProvider.returnedValue = ["param2": "value2"]
                    }

                    it("returned variables are sum of this sets") {
                        let expectedResult = [
                            "param1": "value1",
                            "param2": "value2"
                        ]
                        expect {
                            try sut.getConfiguration(from: .commandLineAndFile).variables
                        }.to(equal(expectedResult))
                    }
                }

                context("when commandLineConfigProvider and fileConfigProvider return not disjoint sets of params") {

                    beforeEach {
                        fileConfigProvider.returnedValue = ["param1": "A", "param2": "A"]
                        commandLineConfigProvider.returnedValue = CommandLineConfiguration(
                            commandName: "commandName",
                            variables: ["param2": "B", "param3": "B"]
                        )
                    }

                    it("returns values from commandLineConfigProvider for repeated keys") {
                        let expectedResult = [
                            "param1": "A",
                            "param2": "B",
                            "param3": "B"
                        ]
                        expect {
                            try sut.getConfiguration(from: .commandLineAndFile).variables
                        }.to(equal(expectedResult))
                    }
                }

                context("when fileConfigProvider throws error") {

                    beforeEach {
                        fileConfigProvider.errorToThrow = MockError()
                        commandLineConfigProvider.returnedValue = CommandLineConfiguration(
                            commandName: "commandName",
                            variables: ["param2": "B", "param3": "B"]
                        )
                    }

                    it("throws expected error") {
                        let expectedError = MockError()
                        expect {
                            try sut.getConfiguration(from: .commandLineAndFile)
                        }.to(throwError(expectedError))
                    }
                }

                context("when commandLineConfigProvider returns error") {

                    beforeEach {
                        fileConfigProvider.returnedValue = ["param1": "A", "param2": "A"]
                        commandLineConfigProvider.errorToThrow = MockError()
                    }

                    it("throws expected error") {
                        let expectedError = MockError()
                        expect {
                            try sut.getConfiguration(from: .commandLineAndFile)
                        }.to(throwError(expectedError))
                    }
                }
            }

            context("when only commandLine source was specified") {
                beforeEach {
                    commandLineConfigProvider.returnedValue = CommandLineConfiguration(
                        commandName: "commandName",
                        variables: ["param1": "value1"]
                    )
                }

                it("does not invoke fileConfigProvider") {
                    try! sut.getConfiguration(from: .commandLine)
                    expect(fileConfigProvider.invocationCount).to(equal(0))
                }

                it("invokes commandLineConfigProvider exactly once") {
                    try! sut.getConfiguration(from: .commandLine)
                    expect(commandLineConfigProvider.invocationCount).to(equal(1))
                }

                it("returns expected value") {
                    let expectedResult = SBGCore.Configuration(
                        commandName: "commandName",
                        variables: ["param1": "value1"]
                    )
                    expect {
                        try sut.getConfiguration(from: .commandLine)
                    }.to(equal(expectedResult))
                }

                context("and commandLineConfigProvider returns error") {

                    beforeEach {
                        commandLineConfigProvider.errorToThrow = MockError()
                    }

                    it("throws expected error") {
                        let expectedError = MockError()
                        expect {
                            try sut.getConfiguration(from: .commandLine)
                        }.to(throwError(expectedError))
                    }
                }
            }
        }
    }
}

class MockCommandLineConfigProvider: CommandLineConfigurationProvider {

    private(set) var invocationCount = 0

    var errorToThrow: Error?
    var returnedValue: CommandLineConfiguration!
    

    func getConfiguration() throws -> CommandLineConfiguration {
        invocationCount += 1
        if let error = errorToThrow {
            throw error
        }
        return returnedValue
    }
}

class MockFileConfigProvider: FileConfigProvider {

    private(set) var file: String!
    private(set) var invocationCount = 0

    var errorToThrow: Error?
    var returnedValue: [String: String]!

    func getConfiguration(from file: String) throws -> [String: String] {
        self.file = file
        invocationCount += 1
        if let error = errorToThrow {
            throw error
        }
        return returnedValue
    }
}
