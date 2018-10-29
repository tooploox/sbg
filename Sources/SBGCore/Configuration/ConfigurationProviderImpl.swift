//
// Created by Karol on 19/10/2018.
//

import Foundation

protocol CommandLineConfigurationProvider {
    func getConfiguration() throws -> CommandLineConfiguration
}

protocol FileConfigProvider {
    func getConfiguration(from file: String) throws -> [String: String]
}

struct Configuration: Equatable {
    let commandName: String
    let variables: [String : String]
}

enum ConfigurationSource {
    case commandLine
    case commandLineAndFile
}

final class ConfigurationProviderImpl: ConfigurationProvider {

    class Constants {
        static let configFileName = "SBGConfig"
    }

    private let commandLineConfigProvider: CommandLineConfigurationProvider
    private let fileConfigProvider: FileConfigProvider

    init(commandLineConfigProvider: CommandLineConfigurationProvider, fileConfigProvider: FileConfigProvider) {
        self.commandLineConfigProvider = commandLineConfigProvider
        self.fileConfigProvider = fileConfigProvider
    }

    func getConfiguration(from source: ConfigurationSource) throws -> Configuration {

        var variables = [String: String]()

        if source == .commandLineAndFile {
            let fileConfig = try fileConfigProvider.getConfiguration(from: Constants.configFileName)
            variables.append(fileConfig)
        }

        let commandLineConfig = try commandLineConfigProvider.getConfiguration()
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
