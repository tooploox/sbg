//
//  DirectoryInitializerTests.swift
//  SBG
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class SBGEnvironmentInitializerTests: QuickSpec {
    
    override func spec() {
        describe("SBGEnvironmentInitializer") {
            var directoryAdder: MockDirectoryAdder!
            var fileAdder: MockFileAdder!
            var pathProvider: MockSBGPathProvider!
            var sut: FoundationSBGEnvironmentInitializer!
            
            beforeEach {
                directoryAdder = MockDirectoryAdder()
                fileAdder = MockFileAdder()
                pathProvider = MockSBGPathProvider()

                sut = FoundationSBGEnvironmentInitializer(
                    directoryAdder: directoryAdder,
                    fileAdder: fileAdder,
                    pathProvider: pathProvider
                )
            }
            
            context("when directory adding and file adding succeeds") {
                it("returns success result") {
                    expect { try sut.initializeEnvironment() }.to(beVoid())
                }
            }
            
            context("when directory adding fails") {
                beforeEach {
                    directoryAdder.errorToThrow = MockError()
                }
                
                it("returns failure result") {
                    expect { try sut.initializeEnvironment() }.to(throwError(MockError()))
                }
            }
            
            context("when adding file fails") {
                beforeEach {
                    fileAdder.errorToThrow = MockError()
                }
                
                it("returns failure result") {
                    expect { try sut.initializeEnvironment() }.to(throwError(MockError()))
                }
            }
        }
    }
}
