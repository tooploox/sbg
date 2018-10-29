//
// Created by Karolina Samorek on 2018-10-29.
//

import Foundation

class FoundationFileReader: FileReader {

    func read(file: String) throws -> Data {
        guard let url = URL(string: file) else {
            throw FileReaderError.cannotCreateUrl(file)
        }

        return try Data(contentsOf: url)
    }
}