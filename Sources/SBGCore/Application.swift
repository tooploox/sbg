//
// Created by Karol on 05/10/2018.
//

import Foundation

protocol GeneratorRunner {
    func run(generator: Generator, parameters: [String: String]) throws
}

protocol GeneratorParser {
    func parseFile(atPath path: String) throws -> Generator
}

protocol ConfigurationProvider {
    func getConfiguration(from source: ConfigurationSource) throws -> Configuration
}

protocol SBGEnvironmentInitializer {
    func initializeEnvironment() throws
}

protocol SBGPathProvider {
    var templatesDirectoryPath: String { get }
    var generatorsDirectoryPath : String { get }
    var sbgConfigFilePath: String { get }
    var sbgConfigName: String { get }
    var sbgDirectoryPath: String { get }

    func generatorPath(forCommand commandName: String) -> String
    func templatePath(forTemplate templateName: String) -> String
}

final public class Application {

    private let configurationProvider: ConfigurationProvider
    private let environmentInitializer: SBGEnvironmentInitializer
    private let generatorParser: GeneratorParser
    private let generatorRunner: GeneratorRunner
    private let helpPrinter: HelpPrinter
    private let pathProvider: SBGPathProvider

    public static var `default`: Application {
        return ApplicationBuilder().build()
    }

    init(configurationProvider: ConfigurationProvider, environmentInitializer: SBGEnvironmentInitializer, generatorParser: GeneratorParser, generatorRunner: GeneratorRunner, helpPrinter: HelpPrinter, pathProvider: SBGPathProvider) {
        self.configurationProvider = configurationProvider
        self.environmentInitializer = environmentInitializer
        self.generatorParser = generatorParser
        self.generatorRunner = generatorRunner
        self.helpPrinter = helpPrinter
        self.pathProvider = pathProvider
    }

    public func run() throws {
        let commandName = try configurationProvider.getConfiguration(from: .commandLine).commandName

        switch commandName {
            case "init":
                try environmentInitializer.initializeEnvironment()
            case "help":
                helpPrinter.printHelp()
            default:
                let configuration = try configurationProvider.getConfiguration(from: .commandLineAndFile)
                
                do {
                    let generator = try generatorParser.parseFile(
                        atPath: pathProvider.generatorPath(forCommand: configuration.commandName)
                    )
                    try generatorRunner.run(generator: generator, parameters: configuration.variables)
                } catch {
                    helpPrinter.printHelp()
                    throw error
                }
        }
    }
}
