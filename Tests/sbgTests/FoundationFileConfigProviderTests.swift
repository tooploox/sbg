//
// Created by Karol on 18/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class FoundationFileConfigProviderTests: QuickSpec {

    override func spec() {
        describe("FoundationFileAdder") {

            var fileReader: MockFileReader!
            var sut: FoundationFileConfigProvider!

            beforeEach {
                fileReader = MockFileReader()
                sut = FoundationFileConfigProvider(fileReader: fileReader)
            }

            context("when file contains correct data") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.sampleData
                }

                it("returns proper dictionary") {
                    expect(sut.getConfiguration(from: MockConstants.file).value).to(equal(MockConstants.sampleDictionary))
                }
            }

            context("when reader cannot read file") {
                beforeEach {
                    fileReader.returnedValue = nil
                }

                it("returns cannotReadFile error") {
                    let result = sut.getConfiguration(from: MockConstants.file)
                    let expectedError = ConfigFileParserError.cannotReadFile(MockConstants.file)
                    expect(result.error).to(equal(expectedError))
                }
            }

            context("when reader returns malformed data") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.malformedData
                }

                it("returns cannotParseData error") {
                    let result = sut.getConfiguration(from: MockConstants.file)
                    let expectedError = ConfigFileParserError.cannotParseData(MockConstants.malformedData)
                    expect(result.error).to(equal(expectedError))
                }
            }

        }
    }
}

private struct MockConstants {
    static let file = "someFile"
    static let sampleText = "{\"key\": \"value\"}"
    static let sampleDictionary = ["key": "value"]
    static let sampleData = MockConstants.sampleText.data(using: .utf8)!
    static let malformedText = "{\"key\": \"value\""
    static let malformedData = MockConstants.malformedText.data(using: .utf8)!
}

private class MockFileReader: FileReader {

    private(set) var file: String!
    private(set) var invocationCount = 0

    var returnedValue: Data!

    func read(file: String) -> Data? {
        self.file = file
        self.invocationCount += 1
        return returnedValue
    }
}