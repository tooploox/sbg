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
                    commandLineConfigProvider.returnedValue = ["param1": "value1"]
                    fileConfigProvider.returnedValue = .success(["param2": "value2"])
                }

                it("returns sum of this sets") {
                    let expectedResult = [
                        "param1": "value1",
                        "param2": "value2"
                    ]
                    expect(sut.getConfiguration().value).to(equal(expectedResult))
                }
            }

            context("when commandLineConfigProvider and fileConfigProvider return not disjoint sets of params") {

                beforeEach {
                    fileConfigProvider.returnedValue = .success(["param1": "A", "param2": "A"])
                    commandLineConfigProvider.returnedValue = ["param2": "B", "param3": "B"]
                }

                it("returns values from commandLineConfigProvider for repeated keys") {
                    let expectedResult = [
                        "param1": "A",
                        "param2": "B",
                        "param3": "B"
                    ]
                    expect(sut.getConfiguration().value).to(equal(expectedResult))
                }
            }

            context("when fileConfigProvider returns error") {

                beforeEach {
                    fileConfigProvider.returnedValue = .failure(.cannotReadFile(ConfigProvider.Constants.configFileName))
                    commandLineConfigProvider.returnedValue = ["param2": "B", "param3": "B"]
                }

                it("returns error") {
                    expect(sut.getConfiguration().error).to(equal(.cannotReadConfigurationFromFile(ConfigProvider.Constants.configFileName)))
                }
            }
        }
    }
}

class MockCommandLineConfigProvider: CommandLineConfigProvider {

    private(set) var invocationCount = 0

    var returnedValue: [String: String]!

    func getConfiguration() -> [String: String] {
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