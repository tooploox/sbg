//
// Created by Karolina Samorek on 26/10/2018.
//

import Foundation
@testable import SBGCore

class MockStringRenderer: StringRenderer {

    private(set) var stringArray = [String]()
    private(set) var contextArray = [[String: String]]()

    private(set) var invocationCount = 0

    var valueToReturn: String!
    var errorToThrow: Error?

    func render(string: String, context: [String: String]) throws -> String {
        stringArray.append(string)
        contextArray.append(context)

        invocationCount += 1
        if let error = errorToThrow {
            throw error
        }

        return valueToReturn
    }
}