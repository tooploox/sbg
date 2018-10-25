//
//  FoundationCommandLineConfigProviderTests.swift
//  AEXML
//
//  Created by Paweł Chmiel on 09/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class FoundationCommandLineConfigProviderTests: QuickSpec {
    
    override func spec() {
        describe("Command line parameters") {
            
            var sut: FoundationCommandLineConfigProvider!
            var commandLineParamsProvider: MockCommandLineParamsProvider!

            beforeEach {
                commandLineParamsProvider = MockCommandLineParamsProvider()
                sut = FoundationCommandLineConfigProvider(commandLineArgsProvider: commandLineParamsProvider)
            }

            context("commandLine parameters are empty") {
                beforeEach {
                    commandLineParamsProvider.parameters = []
                }
                
                it("returns expected error") {
                    let expectedError = CommandLineConfigProviderError.notEnoughArguments
                    expect(sut.getConfiguration().error).to(equal(expectedError))
                }
            }
            
            context("commandLine parameters contains one argument") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["some argument"]
                }
                
                it("returns expected error") {
                    let expectedError = CommandLineConfigProviderError.notEnoughArguments
                    expect(sut.getConfiguration().error).to(equal(expectedError))
                }
            }

            context("commandLine parameters contains odd number of arguments") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["executablePath", "commandName", "--config", "config.json", "--name", "Name", "--filePath"]
                }

                it("returns expected error") {
                    let expectedError = CommandLineConfigProviderError.oddNumberOfArguments
                    expect(sut.getConfiguration().error).to(equal(expectedError))
                }
            }
            
            context("commandLine parameters contains two arguments") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["executablePath", "commandName"]
                }
                
                it("returns configuration with correct command name") {
                    expect(sut.getConfiguration().value?.commandName).to(equal("commandName"))
                }

                it("returns configuration with empty variables dictionary") {
                    expect(sut.getConfiguration().value?.variables).to(beEmpty())
                }
            }
            
            context("commandLine parameters contains more than 2 parameters") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["executablePath", "commandName", "--config", "config.json", "--name", "Name", "--filePath", "filePath"]
                }
                
                it("returns configuration with correct command name") {
                    expect(sut.getConfiguration().value?.commandName).to(equal("commandName"))
                }
                
                it("returns expected variables") {
                    expect(sut.getConfiguration().value?.variables).to(equal(["--config": "config.json", "--filePath": "filePath", "--name": "Name"]))
                }
            }
        }
    }
}

private class MockCommandLineParamsProvider: CommandLineParamsProvider {
    var parameters: [String] = []
}
