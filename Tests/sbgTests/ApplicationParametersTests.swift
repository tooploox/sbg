//
//  ApplicationParametersTests.swift
//  AEXML
//
//  Created by Paweł Chmiel on 09/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class ApplicationParametersTests: QuickSpec {
    
    override func spec() {
        describe("Application parameters") {
            
            var sut: ApplicationParameters!
            var commandLineParameters: [String]!
            
            context("commandLine parameters are empty") {
                beforeEach {
                    commandLineParameters = []
                    sut = ApplicationParameters(commandLineParameters)
                }
                
                it("return an ampty dictionary") {
                    expect(sut.generatorParameters).to(equal([:]))
                }
            }
            
            context("commandLine parameters contains single parameter") {
                beforeEach {
                    commandLineParameters = ["--config", "config.json"]
                    sut = ApplicationParameters(commandLineParameters)
                }
                
                it("returns dictionary with one key and one value") {
                    expect(sut.generatorParameters).to(equal(["--config": "config.json"]))
                }
            }
            
            context("commandLine parameters contains more parameters") {
                beforeEach {
                    commandLineParameters = ["--config", "config.json", "--name", "Name", "--filePath","filePath"]
                    sut = ApplicationParameters(commandLineParameters)
                }
                
                it("return dictionary with parameters") {
                    expect(sut.generatorParameters).to(equal(["--config": "config.json", "--filePath": "filePath", "--name": "Name"]))
                }
        
                it("return dictionary generatorName is set") {
                    expect(sut.generatorName).to(equal("Name"))
                }
            }
        }
    }
}
