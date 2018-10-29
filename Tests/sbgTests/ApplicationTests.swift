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
            var configurationProvider: MockConfigurationProvider!
            var environmentInitializer: MockSBGEnvironmentInitializer!
            var generatorParser: MockGeneratorParser!
            var generatorRunner: MockGeneratorRunner!

            beforeEach {
                configurationProvider = MockConfigurationProvider()
                environmentInitializer = MockSBGEnvironmentInitializer()
                generatorParser = MockGeneratorParser()
                generatorRunner = MockGeneratorRunner()
                sut = Application(
                    configurationProvider: configurationProvider,
                    environmentInitializer: environmentInitializer,
                    generatorParser: generatorParser,
                    generatorRunner: generatorRunner
                )
                configurationProvider.configurationToReturn = SBGCore.Configuration(
                    commandName: "init",
                    variables: [:]
                )
            }

            it("invokes configurationProvider exactly once") {
                try! sut.run()
                expect(configurationProvider.invocationCount).to(equal(1))
            }

            context("when configuration.command name is equal init") {

                it("invokes environmentInitializer exactly once") {
                    try! sut.run()
                    expect(environmentInitializer.invocationCount).to(equal(1))
                }

                context("and environmentInitializer throws error") {
                    beforeEach {
                        environmentInitializer.errorToThrow = MockError()
                    }

                    it("throws expected error") {
                        expect { try sut.run() }.to(throwError(MockError()))
                    }
                }
            }

            context("when configuration.command name is not equal init") {
                beforeEach {
                    configurationProvider.configurationToReturn = SBGCore.Configuration(
                        commandName: "notInit",
                        variables: [:]
                    )
                    generatorParser.generatorToReturn = MockConstants.generator
                }

                context("and everything goes well") {

                    beforeEach {
                        try! sut.run()
                    }

                    it("environmentInitializer is not invoked") {
                        expect(environmentInitializer.invocationCount).to(equal(0))
                    }

                    context("invokes generatorParser") {
                        it("exactly once") {
                            expect(generatorParser.invocationCount).to(equal(1))
                        }

                        it("with correct file path") {
                            expect(generatorParser.path).to(equal(".sbg/generators/notInit.json"))
                        }
                    }

                    context("invokes generatorRunner") {
                        it("exactly once") {
                            expect(generatorRunner.invocationCount).to(equal(1))
                        }

                        it("with generator equal generator returned by generatorParser") {
                            expect(generatorRunner.generator).to(equal(generatorParser.generatorToReturn))
                        }

                        it("with parameters equal variables returned by configurationProvider") {
                            expect(generatorRunner.parameters)
                                .to(equal(configurationProvider.configurationToReturn.variables))
                        }
                    }
                }

                context("and configurationProvider throws error") {
                    beforeEach {
                        configurationProvider.errorToThrow = MockError()
                    }

                    it("throws expected error") {
                        expect { try sut.run() }.to(throwError(MockError()))
                    }
                }

                context("and generatorParser throws error") {
                    beforeEach {
                        generatorParser.errorToThrow = MockError()
                    }

                    it("throws expected error") {
                        expect { try sut.run() }.to(throwError(MockError()))
                    }
                }

                context("and generatorRunner throws error") {
                    beforeEach {
                        generatorRunner.errorToThrow = MockError()
                    }

                    it("throws expected error") {
                        expect { try sut.run() }.to(throwError(MockError()))
                    }
                }
            }
        }
    }
}

private struct MockConstants {
    static let generator = Generator(name: "generator name", steps: [])
}

class MockSBGEnvironmentInitializer: SBGEnvironmentInitializer {

    var invocationCount = 0

    var errorToThrow: Error?

    func initializeEnvironment() throws {
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}

class MockConfigurationProvider: ConfigurationProvider {

    var invocationCount = 0

    var configurationToReturn: SBGCore.Configuration!
    var errorToThrow: Error?

    func getConfiguration() throws -> SBGCore.Configuration {
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }

        return configurationToReturn
    }
}

class MockGeneratorParser: GeneratorParser {

    private(set) var path: String!

    var invocationCount = 0

    var generatorToReturn: Generator!
    var errorToThrow: Error?

    func parse(fromFileAt path: String) throws -> Generator {
        self.path = path
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }

        return generatorToReturn
    }
}

class MockGeneratorRunner: GeneratorRunner {

    private(set) var generator: Generator!
    private(set) var parameters: [String: String]!

    var invocationCount = 0

    var errorToThrow: Error?

    func run(generator: Generator, parameters: [String: String]) throws {
        self.generator = generator
        self.parameters = parameters
        invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}