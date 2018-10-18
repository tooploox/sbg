//
// Created by Karol on 18/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class FoundationConfigFileParserTests: QuickSpec {

    override func spec() {
        describe("FoundationFileAdder") {

            var fileReader: MockFileReader!
            var sut: FoundationConfigFileParser!

            beforeEach {
                fileReader = MockFileReader()
                sut = FoundationConfigFileParser(fileReader: fileReader)
            }

            context("when file contains correct data") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.sampleData
                }

                it("returns proper dictionary") {
                    expect(sut.parse(file: MockConstants.file).value).to(equal(MockConstants.sampleDictionary))
                }
            }

            context("when reader cannot read file") {
                beforeEach {
                    fileReader.returnedValue = nil
                }

                it("returns cannotReadFile error") {
                    let result = sut.parse(file: MockConstants.file)
                    let expectedError = ConfigFileParserError.cannotReadFile(MockConstants.file)
                    expect(result.error).to(equal(expectedError))
                }
            }

            context("when reader returns malformed data") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.malformedData
                }

                it("returns cannotParseData error") {
                    let result = sut.parse(file: MockConstants.file)
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