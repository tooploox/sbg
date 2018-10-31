//
//  DirectoryInitializer.swift
//  SBG
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation

final class FoundationSBGEnvironmentInitializer: SBGEnvironmentInitializer {
    
    private let directoryAdder: DirectoryAdder
    private let fileAdder: FileAdder
    private let pathProvider: SBGPathProvider

    init(directoryAdder: DirectoryAdder, fileAdder: FileAdder, pathProvider: SBGPathProvider) {
        self.directoryAdder = directoryAdder
        self.fileAdder = fileAdder
        self.pathProvider = pathProvider
    }

    func initializeEnvironment() throws {
        try directoryAdder.addDirectory(at: pathProvider.templatesDirectoryPath)
        try directoryAdder.addDirectory(at: pathProvider.generatorsDirectoryPath)
        try fileAdder.addFile(with: pathProvider.sbgConfigName, content: "{}", to: pathProvider.sbgDirectoryPath)
    }
}
