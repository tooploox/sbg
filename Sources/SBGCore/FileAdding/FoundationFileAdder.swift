//
//  FoundationFileAdder.swift
//  SBGCore
//
//  Created by Dawid Markowski on 11/10/2018.
//

import Foundation

protocol StringWriter {
    func write(string: String, to filePath: String) throws
}

final class FoundationFileAdder: FileAdder {
    
    private let pathResolver: PathResolver
    private let stringWriter: StringWriter
    
    init(pathResolver: PathResolver, stringWriter: StringWriter) {
        self.pathResolver = pathResolver
        self.stringWriter = stringWriter
    }

    func addFile(with name: String, content: String, to directory: String) throws {
        let path = pathResolver.createFinalPath(from: directory, name: name)
        try stringWriter.write(string: content, to: path)
    }
}
