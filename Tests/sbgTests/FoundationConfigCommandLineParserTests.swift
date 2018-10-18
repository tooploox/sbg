//
//  FoundationConfigCommandLineParserTests.swift
//  AEXML
//
//  Created by Paweł Chmiel on 09/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class CommandLineParserTests: QuickSpec {
    
    override func spec() {
        describe("Command line parameters") {
            
            var sut: FoundationConfigCommandLineParser!
            var commandLineParamsProvider: MockCommandLineParamsProvider!

            beforeEach {
                commandLineParamsProvider = MockCommandLineParamsProvider()
                sut = FoundationConfigCommandLineParser(commandLineArgsProvider: commandLineParamsProvider)
            }

            context("commandLine parameters are empty") {
                beforeEach {
                    commandLineParamsProvider.parameters = []
                }
                
                it("returns an empty dictionary") {
                    expect(sut.parse()).to(equal([:]))
                }
            }
            
            context("commandLine parameters contains single parameter") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["--config", "config.json"]
                }
                
                it("returns dictionary with one key and one value") {
                    expect(sut.parse()).to(equal(["--config": "config.json"]))
                }
            }
            
            context("commandLine parameters contains more parameters") {
                beforeEach {
                    commandLineParamsProvider.parameters = ["--config", "config.json", "--name", "Name", "--filePath", "filePath"]
                }
                
                it("returns dictionary with parameters") {
                    expect(sut.parse()).to(equal(["--config": "config.json", "--filePath": "filePath", "--name": "Name"]))
                }
            }
        }
    }
}

private class MockCommandLineParamsProvider: CommandLineParamsProvider {
    var parameters: [String] = []
}