//
// Created by Karol on 17/10/2018.
//

import Foundation

final class FoundationStringWriter: StringWriter {
    func write(string: String, to filePath: String) throws {
        try string.write(toFile: filePath, atomically: false, encoding: .utf8)
    }
}