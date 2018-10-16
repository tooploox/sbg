//
//  FoundationFileAdder.swift
//  SBGCore
//
//  Created by Dawid Markowski on 11/10/2018.
//

import Foundation

final class FoundationFileAdder: FileAdder {
    
    private let pathResolver: PathResolver
    
    init(pathResolver: PathResolver) {
        self.pathResolver = pathResolver
    }

    func addFile(with name: String, content: String, to directory: String) throws {
        let path = pathResolver.createFinalPath(from: directory, name: name, fileExtension: "swift")
        
        try content.write(toFile: path, atomically: false, encoding: .utf8)
    }
}
