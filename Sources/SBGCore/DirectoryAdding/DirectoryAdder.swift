//
//  DirectoryAdder.swift
//  SBG
//
//  Created by Dawid Markowski on 25/10/2018.
//

import Foundation

protocol DirectoryAdder {
    func addDirectory(at path: String) throws
}

final class FoundationDirectoryAdder: DirectoryAdder {

    func addDirectory(at path: String) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
}
