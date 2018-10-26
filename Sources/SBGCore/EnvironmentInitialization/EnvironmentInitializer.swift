//
//  DirectoryInitializer.swift
//  SBG
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation

enum SBGEnvironmentInitializerError: Error, Equatable {
    case couldNotInitializeDirectory(String)
    case couldNotAddFile(String)
}

protocol SBGEnvironmentInitializer {
    func initializeEnvironment() -> Result<Void, SBGEnvironmentInitializerError>
}

final class FoundationSBGEnvironmentInitializer: SBGEnvironmentInitializer {
    
    private let directoryAdder: DirectoryAdder
    private let fileAdder: FileAdder
    
    init(directoryAdder: DirectoryAdder, fileAdder: FileAdder) {
        self.directoryAdder = directoryAdder
        self.fileAdder = fileAdder
    }
    
    func initializeEnvironment() -> Result<Void, SBGEnvironmentInitializerError> {
        guard directoryAdder.addDirectory(at: ".sbg/templates").isSuccess else {
            return .failure(.couldNotInitializeDirectory(".sbg/templates"))
        }
        
        guard directoryAdder.addDirectory(at: ".sbg/generators").isSuccess else {
            return .failure(.couldNotInitializeDirectory(".sbg/generators"))
        }
        
        guard fileAdder.addFile(with: "SBGFile", content: "", to: ".sbg").isSuccess else {
            return .failure(.couldNotAddFile("SBGFile"))
        }
        
        return .success(())
    }
}
