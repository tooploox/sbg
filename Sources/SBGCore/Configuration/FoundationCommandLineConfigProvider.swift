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
}

final class FoundationCommandLineConfigProvider: CommandLineConfigProvider {

    private let minimumParametersCount = 2
    let commandLineParamsProvider: CommandLineParamsProvider

    init(commandLineArgsProvider: CommandLineParamsProvider) {
        self.commandLineParamsProvider = commandLineArgsProvider
    }
    
    func getConfiguration() -> Result<CommandLineConfiguration, CommandLineConfigProviderError> {
        let parameters = commandLineParamsProvider.parameters

        guard parameters.count >= minimumParametersCount else {
            return .failure(.notEnoughArguments)
        }
        
        let commandName = parameters[minimumParametersCount-1]
        var dictionary = [String: String]()
        _ = stride(from: minimumParametersCount, to: parameters.count, by: 2).map { index in
            dictionary[parameters[index]] = parameters[index + 1]
        }
        
        return .success(CommandLineConfiguration(commandName: commandName, variables: dictionary))
    }
}
