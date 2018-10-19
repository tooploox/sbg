//
// Created by Karol on 19/10/2018.
//

import Foundation

protocol CommandLineConfigProvider {
    func getConfiguration() -> [String : String]
}

protocol FileConfigProvider {
    func getConfiguration(from file: String) -> Result<[String: String], ConfigFileParserError>
}

enum ConfigProviderError: Error, Equatable {
    case cannotReadConfigurationFromFile(String)
}

class ConfigProvider {

    class Constants {
        static let configFileName = "SBGConfig"
    }

    private let commandLineConfigProvider: CommandLineConfigProvider
    private let fileConfigProvider: FileConfigProvider

    init(commandLineConfigProvider: CommandLineConfigProvider, fileConfigProvider: FileConfigProvider) {
        self.commandLineConfigProvider = commandLineConfigProvider
        self.fileConfigProvider = fileConfigProvider
    }

    func getConfiguration() -> Result<[String: String], ConfigProviderError> {
        let fileConfig = fileConfigProvider.getConfiguration(from: Constants.configFileName)
        let commandLineConfig = commandLineConfigProvider.getConfiguration()

        return fileConfig.ifSuccess { config in
            var config = config
            config.append(commandLineConfig)
            return .success(config)
        }.elseReturn { error in
            return .failure(.cannotReadConfigurationFromFile(Constants.configFileName))
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