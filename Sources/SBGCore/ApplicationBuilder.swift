//
// Created by Karolina Samorek on 2018-10-31.
//

import Foundation

final class ApplicationBuilder {

    func build() -> Application {
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
            pathProvider: pathProvider,
            filesContentProvider: DemoFilesContentProvider()
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

        return Application(
            configurationProvider: configurationProvider,
            environmentInitializer: environmentInitializer,
            generatorParser: generatorParser,
            generatorRunner: generatorRunner,
            pathProvider: pathProvider
        )
    }
}