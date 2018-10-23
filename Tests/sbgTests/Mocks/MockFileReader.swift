//
// Created by Karol on 23/10/2018.
//

import Foundation
@testable import SBGCore

class MockFileReader: FileReader {

    private(set) var file: String!
    private(set) var invocationCount = 0

    var returnedValue: Data?

    func read(file: String) -> Data? {
        self.file = file
        invocationCount += 1
        return returnedValue
    }
}