//
//  DirectoryAdder.swift
//  SBG
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation

enum DirectoryAdderError: Error {
    case couldNotAddDirectory(String)
}

protocol DirectoryAdder {
    func addDirectory(at path: String) -> Result<Void, DirectoryAdderError>
}

final class FoundationDirectoryAdder: DirectoryAdder {

    func addDirectory(at path: String) -> Result<Void, DirectoryAdderError> {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return .success(())
        } catch {
            return .failure(.couldNotAddDirectory(path))
        }
    }
}
