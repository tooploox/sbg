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
                    commandLineConfigProvider.returnedValue = .success(CommandLineConfiguration(
                        commandName: "commandName",
                        variables: ["param1": "value1"]
                    ))
                    fileConfigProvider.returnedValue = .success(["param2": "value2"])
                }

                it("returned variables are sum of this sets") {
                    let expectedResult = [
                        "param1": "value1",
                        "param2": "value2"
                    ]
                    expect(sut.getConfiguration().value?.variables).to(equal(expectedResult))
                }
            }

            context("when commandLineConfigProvider and fileConfigProvider return not disjoint sets of params") {

                beforeEach {
                    fileConfigProvider.returnedValue = .success(["param1": "A", "param2": "A"])
                    commandLineConfigProvider.returnedValue = .success(CommandLineConfiguration(
                        commandName: "commandName",
                        variables: ["param2": "B", "param3": "B"]
                    ))
                }

                it("returns values from commandLineConfigProvider for repeated keys") {
                    let expectedResult = [
                        "param1": "A",
                        "param2": "B",
                        "param3": "B"
                    ]
                    expect(sut.getConfiguration().value?.variables).to(equal(expectedResult))
                }
            }

            context("when fileConfigProvider returns error") {

                beforeEach {
                    fileConfigProvider.returnedValue = .failure(.cannotReadFile(ConfigProvider.Constants.configFileName))
                    commandLineConfigProvider.returnedValue = .success(CommandLineConfiguration(
                        commandName: "commandName",
                        variables: ["param2": "B", "param3": "B"]
                    ))
                }

                it("returns expected error") {
                    let expectedError = ConfigProviderError.cannotReadConfigurationFromFile(ConfigProvider.Constants.configFileName)
                    expect(sut.getConfiguration().error).to(equal(expectedError))
                }
            }
            
            context("when commandLineConfigProvider returns error") {
                
                beforeEach {
                    fileConfigProvider.returnedValue = .success(["param1": "A", "param2": "A"])
                    commandLineConfigProvider.returnedValue = .failure(.notEnoughArguments)
                }
                
                it("returns expected error") {
                    let expectedError = ConfigProviderError.cannotReadCommandLineArguments
                    expect(sut.getConfiguration().error).to(equal(expectedError))
                }
            }
        }
    }
}

class MockCommandLineConfigProvider: CommandLineConfigProvider {

    private(set) var invocationCount = 0

    var returnedValue: Result<CommandLineConfiguration, CommandLineConfigProviderError>!

    func getConfiguration() -> Result<CommandLineConfiguration, CommandLineConfigProviderError> {
        invocationCount += 1
        return returnedValue
    }
}

class MockFileConfigProvider: FileConfigProvider {

    private(set) var file: String!
    private(set) var invocationCount = 0

    var returnedValue: Result<[String: String], ConfigFileParserError>!

    func getConfiguration(from file: String) -> Result<[String: String], ConfigFileParserError> {
        self.file = file
        invocationCount += 1
        return returnedValue
    }
}
