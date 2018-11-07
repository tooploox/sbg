//
//  DirectoryInitializer.swift
//  SBG
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation

protocol FilesContentProvider {
    var sbgConfigFileContent: String { get }
    var templatesFiles: [String: String] { get }
    var generatorsFiles: [String: String] { get }
}

final class SBGEnvironmentInitializerImpl: SBGEnvironmentInitializer {
    
    private let directoryAdder: DirectoryAdder
    private let fileAdder: FileAdder
    private let pathProvider: SBGPathProvider
    private var filesContentProvider: FilesContentProvider

    init(directoryAdder: DirectoryAdder, fileAdder: FileAdder, pathProvider: SBGPathProvider, filesContentProvider: FilesContentProvider) {
        self.directoryAdder = directoryAdder
        self.fileAdder = fileAdder
        self.pathProvider = pathProvider
        self.filesContentProvider = filesContentProvider
    }

    func initializeEnvironment() throws {
        try directoryAdder.addDirectory(at: pathProvider.templatesDirectoryPath)
        try directoryAdder.addDirectory(at: pathProvider.generatorsDirectoryPath)
        try fileAdder.addFile(with: pathProvider.sbgConfigName, content: filesContentProvider.sbgConfigFileContent, to: pathProvider.sbgDirectoryPath)
        try filesContentProvider.templatesFiles.forEach { key, value in
            try fileAdder.addFile(with: key, content: value, to: pathProvider.templatesDirectoryPath)
        }
        try filesContentProvider.generatorsFiles.forEach { key, value in
            try fileAdder.addFile(with: key, content: value, to: pathProvider.generatorsDirectoryPath)
        }
    }
}
