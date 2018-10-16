//
//  PathResolverTests.swift
//  SBGTests
//
//  Created by Dawid Markowski on 15/10/2018.
//


import Foundation
import Quick
import Nimble
@testable import SBGCore

class PathResolverTests: QuickSpec {
    
    override func spec() {
        describe("PathResolver") {
            
            var sut: FoundationPathResolver!
            
            beforeEach {
                sut = FoundationPathResolver()
            }
            
            context("when directory does not end with `/` and file extension does not start with `.`") {
                var returnedPath: String!
                
                beforeEach {
                    returnedPath = sut.createFinalPath(from: MockConstants.directory, name: MockConstants.fileName, fileExtension: MockConstants.fileExtension)
                }
                
                it("should return correct path with appended `/` after directory and appended `.` before file extension") {
                    expect(returnedPath).to(equal(MockConstants.correctPath))
                }
            }
            
            context("when directory ends with `/` and file extension does not start with `.`") {
                var returnedPath: String!
                
                beforeEach {
                    returnedPath = sut.createFinalPath(from: MockConstants.directory + "/", name: MockConstants.fileName, fileExtension: MockConstants.fileExtension)
                }
                
                it("should return correct path with nothing added after directory and appended `.` before file extension") {
                    expect(returnedPath).to(equal(MockConstants.correctPath))
                }
            }
            
            context("when directory does not end with `/` and file extension starts with `.`") {
                var returnedPath: String!
                
                beforeEach {
                    returnedPath = sut.createFinalPath(from: MockConstants.directory, name: MockConstants.fileName, fileExtension: "." + MockConstants.fileExtension)
                }
                
                it("should return correct path with appended `/` after directory without adding `.` before file extension") {
                    expect(returnedPath).to(equal(MockConstants.correctPath))
                }
            }
            
            context("when directory ends with `/` and file extension starts with `.`") {
                var returnedPath: String!
                
                beforeEach {
                    returnedPath = sut.createFinalPath(from: MockConstants.directory + "/", name: MockConstants.fileName, fileExtension: "." +  MockConstants.fileExtension)
                }
                
                it("should return correct path without appending `/` after directory and without adding `.` before file extension") {
                    expect(returnedPath).to(equal(MockConstants.correctPath))
                }
            }
        }
    }
}

private struct MockConstants {
    static let directory = "sample_directory"
    static let fileName = "sample_name"
    static let fileExtension = "sample_extension"
    static let correctPath = "sample_directory/sample_name.sample_extension"
}
