//
// Created by Karolina Samorek on 2018-10-30.
//

import Foundation
@testable import SBGCore

class MockSBGPathProvider: SBGPathProvider {

    private(set) var templatesDirectoryPath: String = ""
    private(set) var generatorsDirectoryPath: String = ""
    private(set) var sbgConfigFilePath: String = ""
    private(set) var sbgConfigName: String = ""
    private(set) var sbgDirectoryPath: String = ""

    var generatorPathToReturn: String?
    var templatePathToReturn: String?

    func generatorPath(forCommand commandName: String) -> String {
        return generatorPathToReturn!
    }

    func templatePath(forTemplate templateName: String) -> String {
        return templatePathToReturn!
    }
}