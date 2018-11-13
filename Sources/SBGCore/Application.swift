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

enum SBGEnvironmentInitializerError: Error, Equatable {
    case couldNotInitializeDirectory(String)
    case couldNotAddFile(String)
}

public class Application {

    private let configurationProvider: ConfigurationProvider
    private let environmentInitializer: SBGEnvironmentInitializer
    private let generatorParser: GeneratorParser
    private let generatorRunner: GeneratorRunner
    private let helpPrinter: HelpPrinter
    private let pathProvider: SBGPathProvider

    public static var `default`: Application = {
        let pathProvider = SBGPathProviderImpl()
        let commandLineConfigProvider = FoundationCommandLineConfigProvider(
            commandLineParamsProvider: CommandLineParamsProviderImpl()
        )
        let fileReader = FoundationFileReader()
        let fileConfigProvider = FoundationFileConfigProvider(fileReader: fileReader)
        let configurationProvider = ConfigurationProviderImpl(
            commandLineConfigProvider: commandLineConfigProvider,
            fileConfigProvider: fileConfigProvider,
            pathProvider: pathProvider
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
            fileAdder: fileAdder,
            pathProvider: pathProvider
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
            directoryAdder: directoryAdder,
            projectManipulator: projectManipulator,
            xcodeprojFileNameProvider: xcodeprojFilenameProvider,
            pathProvider: pathProvider
        )
        let generatorRunner = GeneratorRunnerImpl(stepRunner: stepRunner)
        let helpContentProvider = HelpContentProviderImpl()
        let helpPrinter = HelpPrinterImpl(helpContentProvider: helpContentProvider)

        return Application(
            configurationProvider: configurationProvider,
            environmentInitializer: environmentInitializer,
            generatorParser: generatorParser,
            generatorRunner: generatorRunner,
            helpPrinter: helpPrinter,
            pathProvider: pathProvider
        )
    }()

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
