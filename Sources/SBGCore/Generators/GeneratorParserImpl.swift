//
// Created by Karol on 23/10/2018.
//

import Foundation

enum GeneratorParserError: Error, Equatable {
    case cannotReadFile(String)
    case cannotParseData(String)
}

final class GeneratorParserImpl: GeneratorParser {

    private let fileReader: FileReader

    init(fileReader: FileReader) {
        self.fileReader = fileReader
    }

    func parse(fromFileAt path: String) throws -> Generator {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let content = try fileReader.read(file: path)
        guard let generator = try? decoder.decode(Generator.self, from: content) else {
            throw GeneratorParserError.cannotParseData(path)
        }

        return generator
    }
}