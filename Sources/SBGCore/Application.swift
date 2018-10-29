//
// Created by Karol on 05/10/2018.
//

import Foundation

protocol GeneratorRunner {
    func run(generator: Generator, parameters: [String: String]) throws
}

protocol GeneratorParser {
    func parse(fromFileAt path: String) throws -> Generator
}

protocol ConfigurationProvider {
    func getConfiguration() throws -> Configuration
}

protocol SBGEnvironmentInitializer {
    func initializeEnvironment() throws
}

enum SBGEnvironmentInitializerError: Error, Equatable {
    case couldNotInitializeDirectory(String)
    case couldNotAddFile(String)
}

public class Application {

    private let configurationProvider: ConfigurationProvider
    private let environmentInitializer: SBGEnvironmentInitializer
    private let generatorParser: GeneratorParser
    private let generatorRunner: GeneratorRunner

    public static var `default`: Application = {
        let commandLineConfigProvider = FoundationCommandLineConfigProvider(
            commandLineParamsProvider: CommandLineParamsProviderImpl()
        )
        let fileReader = FoundationFileReader()
        let fileConfigProvider = FoundationFileConfigProvider(fileReader: fileReader)
        let configurationProvider = ConfigurationProviderImpl(
            commandLineConfigProvider: commandLineConfigProvider,
            fileConfigProvider: fileConfigProvider
        )

        let directoryAdder = FoundationDirectoryAdder()
        let pathResolver = FoundationPathResolver()
        let stringWriter = FoundationStringWriter()
        let fileAdder = FoundationFileAdder(
            pathResolver: pathResolver,
            stringWriter: stringWriter
        )
        let environmentInitializer = FoundationSBGEnvironmentInitializer(
            directoryAdder: directoryAdder,
            fileAdder: fileAdder
        )

        let generatorParser = GeneratorParserImpl(fileReader: fileReader)

        let fileRenderer = StencilFileRenderer()
        let stringRenderer = StencilStringRenderer()
        let projectManipulator = XcodeprojProjectManipulator(pathResolver: pathResolver)
        let xcodeprojFilenameProvider = XcodeprojFileNameProviderImpl()
        let stepRunner = StepRunnerImpl(
            fileRenderer: fileRenderer,
            stringRenderer: stringRenderer,
            fileAdder: fileAdder,
            projectManipulator: projectManipulator,
            xcodeprojFileNameProvider: xcodeprojFilenameProvider
        )
        let generatorRunner = GeneratorRunnerImpl(stepRunner: stepRunner)

        return Application(
            configurationProvider: configurationProvider,
            environmentInitializer: environmentInitializer,
            generatorParser: generatorParser,
            generatorRunner: generatorRunner
        )
    }()

    init(configurationProvider: ConfigurationProvider, environmentInitializer: SBGEnvironmentInitializer, generatorParser: GeneratorParser, generatorRunner: GeneratorRunner) {
        self.configurationProvider = configurationProvider
        self.environmentInitializer = environmentInitializer
        self.generatorParser = generatorParser
        self.generatorRunner = generatorRunner
    }

    public func run() throws {
        let configuration = try configurationProvider.getConfiguration()

        switch configuration.commandName {
            case "init":
                try environmentInitializer.initializeEnvironment()
            default:
                let generator = try generatorParser.parse(
                    fromFileAt: ".sbg/generators/\(configuration.commandName).json"
                )
                try generatorRunner.run(generator: generator, parameters: configuration.variables)
        }
    }
}
