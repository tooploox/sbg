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

class SBGEnvironmentInitializerImplTests: QuickSpec {
    
    override func spec() {
        describe("SBGEnvironmentInitializerImpl") {
            var directoryAdder: MockDirectoryAdder!
            var fileAdder: MockFileAdder!
            var pathProvider: MockSBGPathProvider!
            var fileContentProvider: FakeFilesContentProvider!
            var sut: SBGEnvironmentInitializerImpl!
            
            beforeEach {
                directoryAdder = MockDirectoryAdder()
                fileAdder = MockFileAdder()
                pathProvider = MockSBGPathProvider()
                fileContentProvider = FakeFilesContentProvider()

                sut = SBGEnvironmentInitializerImpl(
                    directoryAdder: directoryAdder,
                    fileAdder: fileAdder,
                    pathProvider: pathProvider,
                    filesContentProvider: fileContentProvider
                )
            }
            
            context("when everything goes well") {
                beforeEach {
                    pathProvider.generatorsDirectoryPath = MockConstants.generatorsDirectory
                    pathProvider.templatesDirectoryPath = MockConstants.templatesDirectory
                    pathProvider.sbgConfigName = MockConstants.sbgConfigFileName
                    try! sut.initializeEnvironment()
                }

                describe("directoryAdder") {
                    it("is invoked exactly twice") {
                        expect(directoryAdder.invocationCount).to(equal(2))
                    }

                    it("is invokes with correct paths") {
                        let expectedPaths = [
                            pathProvider.templatesDirectoryPath,
                            pathProvider.generatorsDirectoryPath
                        ]

                        expect(directoryAdder.paths).to(equal(expectedPaths))
                    }
                }

                describe("fileAdder") {
                    it("is invoked four times") {
                        expect(fileAdder.invocationCount).to(equal(4))
                    }

                    it("is invoked with correct names") {
                        let expectedNames = [
                            pathProvider.sbgConfigName,
                            "template1",
                            "template2",
                            "generator1"
                        ]
                        expect(fileAdder.names).to(contain(expectedNames))
                    }

                    it("is invoked with correct contents") {
                        let expectedContentsArray = [
                            fileContentProvider.sbgConfigFileContent,
                            "content1",
                            "content2",
                            "content3"
                        ]
                        expect(fileAdder.contentsArray).to(contain(expectedContentsArray))
                    }

                    it("is invoked with correct directories") {
                        let expectedDirectories = [
                            pathProvider.sbgDirectoryPath,
                            pathProvider.templatesDirectoryPath,
                            pathProvider.templatesDirectoryPath,
                            pathProvider.generatorsDirectoryPath
                        ]
                        expect(fileAdder.directories).to(equal(expectedDirectories))
                    }
                }
            }
            
            context("when directory adding fails") {
                beforeEach {
                    directoryAdder.errorsToThrow = [MockError()]
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

private struct MockConstants {
    static let generatorsDirectory = "generatorsDirectory"
    static let templatesDirectory = "templatesDirectory"
    static let sbgConfigFileName = "fileName"
}

final class FakeFilesContentProvider: FilesContentProvider {
    private(set) var sbgConfigFileContent: String = "sbgFileContent"
    private(set) var templatesFiles: [String: String] = [
        "template1": "content1",
        "template2": "content2"
    ]
    private(set) var generatorsFiles: [String: String] = [
        "generator1": "content3"
    ]
}