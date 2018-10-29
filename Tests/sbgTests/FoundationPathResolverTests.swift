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
            var returnedPath: String!
            
            beforeEach {
                sut = FoundationPathResolver()
            }
            
            context("when directory does not end with `/`") {
                beforeEach {
                    returnedPath = sut.createFinalPath(from: MockConstants.directory, name: MockConstants.fileName)
                }

                it("returns correct path with appended `/` after directory") {
                    expect(returnedPath).to(equal(MockConstants.correctPath))
                }
            }
            
            context("when directory ends with `/` ") {
                beforeEach {
                    returnedPath = sut.createFinalPath(from: MockConstants.directory + "/", name: MockConstants.fileName)
                }

                it("returns correct path with nothing added after directory") {
                    expect(returnedPath).to(equal(MockConstants.correctPath))
                }
            }
        }
    }
}

private struct MockConstants {
    static let directory = "sample_directory"
    static let fileName = "sample_name"
    static let correctPath = "sample_directory/sample_name"
}
