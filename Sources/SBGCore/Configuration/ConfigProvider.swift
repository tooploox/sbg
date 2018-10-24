//
// Created by Karol on 19/10/2018.
//

import Foundation

protocol CommandLineConfigProvider {
    func getConfiguration() -> Result<CommandLineConfiguration, CommandLineConfigProviderError>
}

protocol FileConfigProvider {
    func getConfiguration(from file: String) -> Result<[String: String], ConfigFileParserError>
}

struct Configuration {
    let commandName: String
    let variables: [String : String]
}

enum ConfigProviderError: Error, Equatable {
    case cannotReadConfigurationFromFile(String)
    case cannotReadCommandLineArguments
}

final class ConfigProvider {

    class Constants {
        static let configFileName = "SBGConfig"
    }

    private let commandLineConfigProvider: CommandLineConfigProvider
    private let fileConfigProvider: FileConfigProvider

    init(commandLineConfigProvider: CommandLineConfigProvider, fileConfigProvider: FileConfigProvider) {
        self.commandLineConfigProvider = commandLineConfigProvider
        self.fileConfigProvider = fileConfigProvider
    }

    func getConfiguration() -> Result<Configuration, ConfigProviderError> {
        let fileConfig = fileConfigProvider.getConfiguration(from: Constants.configFileName)
        let commandLineConfigResult = commandLineConfigProvider.getConfiguration()

        return commandLineConfigResult.ifSuccess { commandLineConfiguration in
            return fileConfig.ifSuccess { fileConfiguration in
                var variables = fileConfiguration
                variables.append(commandLineConfiguration.variables)
                
                return .success(Configuration(
                    commandName: commandLineConfiguration.commandName,
                    variables: variables
                ))
            }.elseReturn { error in
                    .failure(.cannotReadConfigurationFromFile(Constants.configFileName))
            }
        }.elseReturn { commandLineConfigProviderError in
            return .failure(.cannotReadCommandLineArguments)
        }
        
        
    }
}

private extension Dictionary {
    mutating func append(_ anotherDictionary: Dictionary) {
        for (key, value) in anotherDictionary {
            self[key] = value
        }
    }
}
