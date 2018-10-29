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
                sut = FoundationCommandLineConfigProvider(commandLineParamsProvider: commandLineParamsProvider)
            }

            context("commandLine parameters are empty") {
                beforeEach {
                    commandLineParamsProvider.parameters = []
                }
                
                it("throws expected error") {
                    let expectedError = CommandLineConfigProviderError.notEnoughArguments
                    expect { try sut.getConfiguration() }.to(throwError(expectedError))
                }
            }
            
            context("commandLine parameters contains one argument") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["some argument"]
                }
                
                it("throws expected error") {
                    let expectedError = CommandLineConfigProviderError.notEnoughArguments
                    expect { try sut.getConfiguration() }.to(throwError(expectedError))
                }
            }

            context("commandLine parameters contains odd number of arguments") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["executablePath", "commandName", "--config", "config.json", "--name", "Name", "--filePath"]
                }

                it("throws expected error") {
                    let expectedError = CommandLineConfigProviderError.oddNumberOfArguments
                    expect { try sut.getConfiguration() }.to(throwError(expectedError))
                }
            }
            
            context("commandLine parameters contains two arguments") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["executablePath", "commandName"]
                }
                
                it("returns configuration with correct command name") {
                    expect { try sut.getConfiguration().commandName }.to(equal("commandName"))
                }

                it("returns configuration with empty variables dictionary") {
                    expect { try sut.getConfiguration().variables }.to(beEmpty())
                }
            }
            
            context("commandLine parameters contains more than 2 parameters") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["executablePath", "commandName", "--config", "config.json", "--name", "Name", "--filePath", "filePath"]
                }

                it("returns configuration with correct command name") {
                    expect { try sut.getConfiguration().commandName }.to(equal("commandName"))
                }
                
                it("returns expected variables") {
                    expect { try sut.getConfiguration().variables }.to(equal(["--config": "config.json", "--filePath": "filePath", "--name": "Name"]))
                }
            }
        }
    }
}

private class MockCommandLineParamsProvider: CommandLineParamsProvider {
    var parameters: [String] = []
}
