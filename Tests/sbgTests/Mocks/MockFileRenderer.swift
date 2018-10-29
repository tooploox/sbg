//
// Created by Karolina Samorek on 26/10/2018.
//

import Foundation
@testable import SBGCore

class MockFileRenderer: FileRenderer {

    private(set) var name: String!
    private(set) var invocationCount = 0

    var renderingError: Error?
    var valueToReturn: String!

    func renderTemplate(name: String, context: [String : Any]?) throws -> String {
        self.name = name
        invocationCount += 1

        if let error = renderingError {
            throw error
        }

        return valueToReturn
    }
}