//
// Created by Karol on 19/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class ConfigProviderTests: QuickSpec {

    override func spec() {
        describe("ConfigProvider") {

            var commandLineConfigProvider: MockCommandLineConfigProvider!
            var fileConfigProvider: MockFileConfigProvider!
            var sut: ConfigProvider!

            beforeEach {
                commandLineConfigProvider = MockCommandLineConfigProvider()
                fileConfigProvider = MockFileConfigProvider()
                sut = ConfigProvider(
                    commandLineConfigProvider: commandLineConfigProvider,
                    fileConfigProvider: fileConfigProvider
                )
            }

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
                    expect { try sut.getConfiguration().variables }.to(equal(expectedResult))
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
                    expect { try sut.getConfiguration().variables }.to(equal(expectedResult))
                }
            }

            context("when fileConfigProvider throws error") {

                beforeEach {
                    fileConfigProvider.errorToThrow = ConfigFileParserError.cannotReadFile(ConfigProvider.Constants.configFileName)
                    commandLineConfigProvider.returnedValue = CommandLineConfiguration(
                        commandName: "commandName",
                        variables: ["param2": "B", "param3": "B"]
                    )
                }

                it("returns expected error") {
                    let expectedError = ConfigFileParserError.cannotReadFile(ConfigProvider.Constants.configFileName)
                    expect { try sut.getConfiguration() }.to(throwError(expectedError))
                }
            }
            
            context("when commandLineConfigProvider returns error") {
                
                beforeEach {
                    fileConfigProvider.returnedValue = ["param1": "A", "param2": "A"]
                    commandLineConfigProvider.errorToThrow = CommandLineConfigProviderError.notEnoughArguments
                }
                
                it("returns expected error") {
                    let expectedError = CommandLineConfigProviderError.notEnoughArguments
                    expect { try sut.getConfiguration() }.to(throwError(expectedError))
                }
            }
        }
    }
}

class MockCommandLineConfigProvider: CommandLineConfigProvider {

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
