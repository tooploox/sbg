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
            var sut: FoundationSBGEnvironmentInitializer!
            
            beforeEach {
                directoryAdder = MockDirectoryAdder()
                fileAdder = MockFileAdder()

                sut = FoundationSBGEnvironmentInitializer(directoryAdder: directoryAdder, fileAdder: fileAdder)
            }
            
            context("when directory adding and file adding succeeds") {
                var result: Result<Void, SBGEnvironmentInitializerError>!
                
                beforeEach {
                    directoryAdder.returnedValue = .success(())
                    fileAdder.returnedValue = .success(())

                    result = sut.initializeEnvironment()
                }
                
                it("returns success result") {
                    expect(result.value).to(beVoid())
                }
            }
            
            context("when directory adding fails") {
                var result: Result<Void, SBGEnvironmentInitializerError>!
                
                beforeEach {
                    directoryAdder.returnedValue = .failure(DirectoryAdderError.couldNotAddDirectory("sample_directory"))
                    fileAdder.returnedValue = .success(())
                    result = sut.initializeEnvironment()
                }
                
                it("returns failure result") {
                    expect(result.error).to(equal(.couldNotInitializeDirectory(".sbg/templates")))
                }
            }
            
            context("when adding file fails") {
                var result: Result<Void, SBGEnvironmentInitializerError>!
                
                beforeEach {
                    directoryAdder.returnedValue = .success(())
                    fileAdder.returnedValue = .failure(FileAdderError.writingFailed("sample_file"))
                    result = sut.initializeEnvironment()
                }
                
                it("returns failure result") {
                    expect(result.error).to(equal(.couldNotAddFile("SBGFile")))
                }
            }
        }
    }
}
