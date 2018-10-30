//
// Created by Karolina Samorek on 2018-10-30.
//

import Foundation

class SBGPathProviderImpl: SBGPathProvider {

    let templatesDirectoryPath = ".sbg/templates"
    let generatorsDirectoryPath  = ".sbg/generators"
    let sbgConfigFilePath = ".sbg/SBGConfig"
    let sbgConfigName = "SBGConfig"
    let sbgDirectoryPath = ".sbg"

    func generatorPath(forCommand commandName: String) -> String {
        return "\(generatorsDirectoryPath)/\(commandName).json"
    }

    func templatePath(forTemplate templateName: String) -> String {
        return templatesDirectoryPath + templateName
    }
}