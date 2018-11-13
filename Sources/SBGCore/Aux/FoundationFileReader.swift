//
// Created by Karolina Samorek on 2018-10-29.
//

import Foundation

final class FoundationFileReader: FileReader {

    func read(file: String) throws -> Data {
        return try Data(contentsOf: URL(fileURLWithPath: file))
    }
}