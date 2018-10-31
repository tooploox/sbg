//
// Created by Karolina Samorek on 2018-10-31.
//

import Foundation

final class DemoFilesContentProvider: FilesContentProvider {
    private(set) var sbgConfigFileContent: String = "{}"
    private(set) var templatesFiles: [String: String] = [:]
    private(set) var generatorsFiles: [String: String] = [:]
}