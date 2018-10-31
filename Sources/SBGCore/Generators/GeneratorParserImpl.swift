//
// Created by Karol on 23/10/2018.
//

import Foundation

final class GeneratorParserImpl: GeneratorParser {

    private let fileReader: FileReader

    init(fileReader: FileReader) {
        self.fileReader = fileReader
    }

    func parseFile(atPath path: String) throws -> Generator {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let content = try fileReader.read(file: path)
        return try decoder.decode(Generator.self, from: content)
    }
}