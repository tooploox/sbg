//
// Created by Karolina Samorek on 2018-10-30.
//

import Foundation
@testable import SBGCore

class MockSBGPathProvider: SBGPathProvider {

    var templatesDirectoryPath: String = ""
    var generatorsDirectoryPath: String = ""
    var sbgConfigFilePath: String = ""
    var sbgConfigName: String = ""
    var sbgDirectoryPath: String = ""

    var generatorPathToReturn: String?
    var templatePathToReturn: String?

    func generatorPath(forCommand commandName: String) -> String {
        return generatorPathToReturn!
    }

    func templatePath(forTemplate templateName: String) -> String {
        return templatePathToReturn!
    }
}