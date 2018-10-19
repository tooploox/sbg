//
//  FoundationFileAdder.swift
//  SBGCore
//
//  Created by Dawid Markowski on 11/10/2018.
//

import Foundation

enum StringWriterError: Error {
    case writingFailed(String)
}

protocol StringWriter {
    func write(string: String, to filePath: String) -> Result<Void, StringWriterError>
}

final class FoundationFileAdder: FileAdder {
    
    private let pathResolver: PathResolver
    private let stringWriter: StringWriter
    
    init(pathResolver: PathResolver, stringWriter: StringWriter) {
        self.pathResolver = pathResolver
        self.stringWriter = stringWriter
    }

    func addFile(with name: String, content: String, to directory: String) -> Result<Void, FileAdderError> {
        let path = pathResolver.createFinalPath(from: directory, name: name, fileExtension: "swift")

        if stringWriter.write(string: content, to: path).isSuccess {
            return .success(())
        } else {
            return .failure(FileAdderError.writingFailed(path))
        }
    }
}
