//
//  CommandLineParserTests.swift
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
            
            var sut: CommandLineParser!
            var commandLineParameters: [String]!
            
            context("commandLine parameters are empty") {
                beforeEach {
                    commandLineParameters = []
                    sut = CommandLineParser(commandLineParameters)
                }
                
                it("returns an ampty dictionary") {
                    expect(sut.applicationParameters.generatorParameters).to(equal([:]))
                }
            }
            
            context("commandLine parameters contains single parameter") {
                beforeEach {
                    commandLineParameters = ["--config", "config.json"]
                    sut = CommandLineParser(commandLineParameters)
                }
                
                it("returns dictionary with one key and one value") {
                    expect(sut.applicationParameters.generatorParameters).to(equal(["--config": "config.json"]))
                }
            }
            
            context("commandLine parameters contains more parameters") {
                beforeEach {
                    commandLineParameters = ["--config", "config.json", "--name", "Name", "--filePath", "filePath"]
                    sut = CommandLineParser(commandLineParameters)
                }
                
                it("returns dictionary with parameters") {
                    expect(sut.applicationParameters.generatorParameters).to(equal(["--config": "config.json", "--filePath": "filePath", "--name": "Name"]))
                }
                
                it("generator name is set") {
                    expect(sut.applicationParameters.generatorName).to(equal("Name"))
                }
            }
        }
    }
}
