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

    private let commandLineConfigProvider: CommandLineConfigurationProvider
    private let fileConfigProvider: FileConfigProvider
    private let pathProvider: SBGPathProvider

    init(commandLineConfigProvider: CommandLineConfigurationProvider, fileConfigProvider: FileConfigProvider, pathProvider: SBGPathProvider) {
        self.commandLineConfigProvider = commandLineConfigProvider
        self.fileConfigProvider = fileConfigProvider
        self.pathProvider = pathProvider
    }

    func getConfiguration(from source: ConfigurationSource) throws -> Configuration {

        var variables = [String: String]()

        if source == .commandLineAndFile {
            let fileConfig = try fileConfigProvider.getConfiguration(from: pathProvider.sbgConfigFilePath)
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
