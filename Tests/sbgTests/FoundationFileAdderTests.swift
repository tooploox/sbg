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

                    it("invokes path resolver with correct file extension") {
                        expect(pathResolver.fileExtension).to(equal(MockConstants.correctFileExtension))
                    }
                }

                context("when string writer fails") {
                    beforeEach {
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

private class MockPathResolver: PathResolver {
    
    private(set) var directory: String!
    private(set) var name: String!
    private(set) var fileExtension: String!
    
    private(set) var invocationCount = 0
    
    func createFinalPath(from directory: String, name: String, fileExtension: String) -> String {
        invocationCount += 1
        
        self.directory = directory
        self.name = name
        self.fileExtension = fileExtension
        
        return MockConstants.samplePath
    }
}

private class MockStringWriter: StringWriter {

    private(set) var string: String!
    private(set) var filePath: String!
    private(set) var invocationCount = 0

    var errorToThrow: Error?

    func write(string: String, to filePath: String) throws {
        self.string = string
        self.filePath = filePath
        self.invocationCount += 1

        if let error = errorToThrow {
            throw error
        }
    }
}
