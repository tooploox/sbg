//
// Created by Karol on 23/10/2018.
//

import Foundation

enum GeneratorParserError: Error, Equatable {
    case cannotReadFile(String)
    case cannotParseData(String)
}

final class GeneratorParser {

    private let fileReader: FileReader

    init(fileReader: FileReader) {
        self.fileReader = fileReader
    }

    func parse(fromFileAt path: String) -> Result<Generator, GeneratorParserError> {
        guard let content = fileReader.read(file: path) else {
            return .failure(.cannotReadFile(path))
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let generator = try? decoder.decode(Generator.self, from: content) else {
            return .failure(.cannotParseData(path))
        }

        return .success(generator)
    }
}