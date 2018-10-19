//
//  PathResolver.swift
//  SBGCore
//
//  Created by Dawid Markowski on 15/10/2018.
//

import Foundation

protocol PathResolver {
    func createFinalPath(from directory: String, name: String, fileExtension: String) -> String
}

final class FoundationPathResolver: PathResolver {
    
    func createFinalPath(from directory: String, name: String, fileExtension: String) -> String {
        var finalPath = ""
        
        finalPath.append(directory)
        
        if directory.last != "/" {
            finalPath.append("/")
        }
        
        finalPath.append(name)
        
        if !fileExtension.starts(with: ".") {
            finalPath.append(".")
        }
        
        finalPath.append(fileExtension)
        
        return finalPath
    }
}
