//
// Created by Karol on 18/10/2018.
//

import Foundation

protocol FileReader {
    func read(file: String) -> Data?
}

enum ConfigFileParserError: Error, Equatable {
    case cannotReadFile(String)
    case cannotParseData(Data)
}

class FoundationFileConfigProvider: FileConfigProvider {

    private let fileReader: FileReader

    init(fileReader: FileReader) {
        self.fileReader = fileReader
    }

    func getConfiguration(from file: String) throws -> [String: String] {
        guard let fileData = fileReader.read(file: file) else {
            throw ConfigFileParserError.cannotReadFile(file)
        }

        guard let fileDictionary = (try? JSONSerialization.jsonObject(with: fileData)) as? [String: String] else {
            throw ConfigFileParserError.cannotParseData(fileData)
        }

        return fileDictionary
    }
}
