//
// Created by Karol on 19/10/2018.
//

import Foundation

protocol CommandLineConfigProvider {
    func getConfiguration() throws -> CommandLineConfiguration
}

protocol FileConfigProvider {
    func getConfiguration(from file: String) throws -> [String: String]
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

    func getConfiguration() throws -> Configuration {
        let fileConfig = try fileConfigProvider.getConfiguration(from: Constants.configFileName)
        let commandLineConfig = try commandLineConfigProvider.getConfiguration()

        var variables = fileConfig
        variables.append(commandLineConfig.variables)

        return Configuration(
            commandName: commandLineConfig.commandName,
            variables: variables
        )
    }
}

private extension Dictionary {
    mutating func append(_ anotherDictionary: Dictionary) {
        for (key, value) in anotherDictionary {
            self[key] = value
        }
    }
}
