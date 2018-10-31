//
//  FoundationFileAdderTests.swift
//  SBGTests
//
//  Created by Dawid Markowski on 15/10/2018.
//


import Foundation
import Quick
import Nimble
@testable import SBGCore

class FoundationFileAdderTests: QuickSpec {
    
    override func spec() {
        describe("FoundationFileAdder") {
            
            var sut: FoundationFileAdder!
            var pathResolver: MockPathResolver!
            var stringWriter: MockStringWriter!
            
            beforeEach {
                pathResolver = MockPathResolver()
                stringWriter = MockStringWriter()
                sut = FoundationFileAdder(pathResolver: pathResolver, stringWriter: stringWriter)
            }
            
            describe("adding file") {

                context("stringWriter returns success") {
                    beforeEach {
                        pathResolver.returnedValue = MockConstants.samplePath
                        try! sut.addFile(with: MockConstants.sampleName, content: MockConstants.sampleContent, to: MockConstants.sampleDirectory)
                    }

                    it("invokes path resolver exactly once") {
                        expect(pathResolver.invocationCount).to(equal(1))
                    }

                    it("invokes path resolver with correct file name") {
                        expect(pathResolver.name).to(equal(MockConstants.sampleName))
                    }

                    it("invokes path resolver with correct directory") {
                        expect(pathResolver.directory).to(equal(MockConstants.sampleDirectory))
                    }
                }

                context("when string writer fails") {
                    beforeEach {
                        pathResolver.returnedValue = MockConstants.samplePath
                        stringWriter.errorToThrow = MockError()
                    }

                    it("throws FileAdderError.writingFailed error") {
                        expect {
                            try sut.addFile(
                                with: MockConstants.sampleName,
                                content: MockConstants.sampleContent,
                                to: MockConstants.sampleDirectory
                            )
                        }.to(throwError(MockError()))
                    }
                }
            }
        }
    }
}

private struct MockConstants {
    static let correctFileExtension = "swift"
    static let sampleName = "sample_name"
    static let sampleContent = "sample_content"
    static let sampleDirectory = "sample_directory"
    static let samplePath = "sample_path"
}
