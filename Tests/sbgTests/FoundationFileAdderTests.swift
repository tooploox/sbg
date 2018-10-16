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
            
            beforeEach {
                pathResolver = MockPathResolver()
                sut = FoundationFileAdder(pathResolver: pathResolver)
            }
            
            context("when adding file") {
                beforeEach {
                    try! sut.addFile(with: MockConstants.sampleName, content: MockConstants.sampleContent, to: MockConstants.sampleDirectory)
                }
                
                it("should invoke path resolver excactly once") {
                    expect(pathResolver.invocationCount).to(equal(1))
                }
                
                it("should invoke path resolver with correct file name") {
                    expect(pathResolver.name).to(equal(MockConstants.sampleName))
                }
                
                it("should invoke path resolver with correct directory") {
                    expect(pathResolver.directory).to(equal(MockConstants.sampleDirectory))
                }
                
                it("should invoke path resolver with correct file extension") {
                    expect(pathResolver.fileExtension).to(equal(MockConstants.correctFileExtension))
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
