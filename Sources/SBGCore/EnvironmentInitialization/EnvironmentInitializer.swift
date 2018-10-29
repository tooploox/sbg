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
    
    init(directoryAdder: DirectoryAdder, fileAdder: FileAdder) {
        self.directoryAdder = directoryAdder
        self.fileAdder = fileAdder
    }
    
    func initializeEnvironment() throws {
        try directoryAdder.addDirectory(at: ".sbg/templates")
        try directoryAdder.addDirectory(at: ".sbg/generators")
        try fileAdder.addFile(with: "SBGConfig", content: "", to: ".sbg")
    }
}
