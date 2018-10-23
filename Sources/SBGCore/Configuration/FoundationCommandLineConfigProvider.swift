//
//  FoundationCommandLineConfigProvider.swift
//
//  Created by Paweł Chmiel on 12/10/2018.
//

import Foundation

protocol CommandLineParamsProvider {
    var parameters: [String] { get }
}

final class FoundationCommandLineConfigProvider: CommandLineConfigProvider {

    let commandLineParamsProvider: CommandLineParamsProvider

    init(commandLineArgsProvider: CommandLineParamsProvider) {
        self.commandLineParamsProvider = commandLineArgsProvider
    }
    
    func getConfiguration() -> [String : String] {
        let parameters = commandLineParamsProvider.parameters

        guard !parameters.isEmpty else { return [:] }
        
        var dictionary = [String: String]()
        _ = stride(from: 0, to: parameters.count, by: 2).map { index in
            dictionary[parameters[index]] = parameters[index + 1]
        }
        
        return dictionary
    }
}
