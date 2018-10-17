//
//  CommandLineParser.swift
//
//  Created by Paweł Chmiel on 12/10/2018.
//

import Foundation

final class CommandLineParser {
    
    let applicationParameters: ApplicationParameters
    
    init(_ commandLineParameters: [String]) {
        let parameters = CommandLineParser.convert(commandLineParameters)
        applicationParameters = ApplicationParameters(generatorName: parameters["--name"] ?? "", generatorParameters: parameters)
    }
    
    private static func convert(_ parameters: [String]) -> [String : String] {
        guard !parameters.isEmpty else { return [:] }
        
        var dictionary = [String: String]()
        _ = stride(from: 0, to: parameters.count, by: 2).map { index in
            dictionary[parameters[index]] = parameters[index + 1]
        }
        
        return dictionary
    }
}
