//
// Created by Karol on 17/10/2018.
//

import Foundation

class FoundationStringWriter: StringWriter {
    func write(string: String, to filePath: String) -> Result<Void, StringWriterError> {
        do {
            try string.write(toFile: filePath, atomically: false, encoding: .utf8)
            return .success(())
        } catch {
            return .failure(.writingFailed(error.localizedDescription))
        }
    }
}