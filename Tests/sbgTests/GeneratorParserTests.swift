//
// Created by Karol on 23/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import SBGCore

class GeneratorParserTests: QuickSpec {

    override func spec() {
        describe("GeneratorParser") {

            var fileReader: MockFileReader!
            var sut: GeneratorParser!

            beforeEach {
                fileReader = MockFileReader()
                sut = GeneratorParser(fileReader: fileReader)
            }

            context("when file reader throws error") {
                beforeEach {
                    fileReader.errorToThrow = MockError()
                }

                it("returns expected error") {
                    expect { try sut.parse(fromFileAt: MockConstants.filePath) }.to(throwError(MockError()))
                }
            }

            context("when file reader returns incorrectData") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.incorrectData
                }

                it("returns expected error") {
                    let expectedError = GeneratorParserError.cannotParseData(MockConstants.filePath)
                    expect { try sut.parse(fromFileAt: MockConstants.filePath) }.to(throwError(expectedError))
                }
            }

            context("when file reader returns correctData") {
                beforeEach {
                    fileReader.returnedValue = MockConstants.correctData
                }

                it("returns parsed generator") {
                    let expectedGenerator = Generator(
                        name: "clean_module",
                        steps: [
                            Step(
                                template: "connector.stencil",
                                fileName: "{{module_name}}Connector.swift",
                                group: "{{connectors_path}}/{{module_name}}",
                                target: "targetName"
                            )
                        ]
                    )
                    expect { try sut.parse(fromFileAt: MockConstants.filePath) }.to(equal(expectedGenerator))
                }
            }
        }
    }
}

private class MockConstants {
    static let filePath = "path/to/file"
    static let incorrectData = try! JSONSerialization.data(withJSONObject: [
        "not_needed_key": "not_needed_value"
    ])
    static let correctData = try! JSONSerialization.data(withJSONObject: [
        "name": "clean_module",
        "steps": [
            [
                "template": "connector.stencil",
                "file_name": "{{module_name}}Connector.swift",
                "group": "{{connectors_path}}/{{module_name}}",
                "target": "targetName"
            ]
        ]
    ])
}
