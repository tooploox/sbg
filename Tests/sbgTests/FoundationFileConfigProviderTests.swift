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
                    expect { try sut.getConfiguration(from: MockConstants.file) }.to(equal(MockConstants.sampleDictionary))
                }
            }

            context("when reader cannot read file") {
                beforeEach {
                    fileReader.returnedValue = nil
                }

                it("throws cannotReadFile error") {
                    let expectedError = ConfigFileParserError.cannotReadFile(MockConstants.file)
                    expect { try sut.getConfiguration(from: MockConstants.file) }.to(throwError(expectedError))
                }
            }

            context("when reader returns malformed data") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.malformedData
                }

                it("throws cannotParseData error") {
                    let expectedError = ConfigFileParserError.cannotParseData(MockConstants.malformedData)
                    expect { try sut.getConfiguration(from: MockConstants.file) }.to(throwError(expectedError))
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