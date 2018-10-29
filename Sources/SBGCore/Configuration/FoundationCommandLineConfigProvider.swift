//
//  FoundationCommandLineConfigProvider.swift
//
//  Created by Paweł Chmiel on 12/10/2018.
//

import Foundation

protocol CommandLineParamsProvider {
    var parameters: [String] { get }
}

struct CommandLineConfiguration {
    
    let commandName: String
    let variables: [String : String]
}

enum CommandLineConfigProviderError: Error {
    case notEnoughArguments
    case oddNumberOfArguments
}

final class FoundationCommandLineConfigProvider: CommandLineConfigurationProvider {

    private let minimumParametersCount = 2
    let commandLineParamsProvider: CommandLineParamsProvider

    init(commandLineParamsProvider: CommandLineParamsProvider) {
        self.commandLineParamsProvider = commandLineParamsProvider
    }
    
    func getConfiguration() throws -> CommandLineConfiguration {
        let parameters = commandLineParamsProvider.parameters

        guard parameters.count >= minimumParametersCount else {
            throw CommandLineConfigProviderError.notEnoughArguments
        }

        guard parameters.count % 2 == 0 else {
            throw CommandLineConfigProviderError.oddNumberOfArguments
        }
        
        let commandName = parameters[1]
        var dictionary = [String: String]()
        _ = stride(from: minimumParametersCount, to: parameters.count, by: 2).map { index in
            dictionary[parameters[index]] = parameters[index + 1]
        }
        
        return CommandLineConfiguration(commandName: commandName, variables: dictionary)
    }
}
