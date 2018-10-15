//
// Created by Karol on 10/10/2018.
//

import Foundation
import xcodeproj
import PathKit

public class XcodeprojProjectManipulator{

    public init() {

    }

    public func addFileToXCodeProject(groupPath: String, fileName: String) {
        let fileManager = FileManager.default
//        let currentPath = FileManager.default.currentDirectoryPath
        let projectPath = "/Users/karol/Documents/Praca/misc/TestApp/TestApp"
        let xcodeprojFile = try! fileManager.contentsOfDirectory(atPath: projectPath).filter { $0.contains(".xcodeproj") }.first!
        let xcodeprojPath = projectPath + "/" + xcodeprojFile
        let filePath = projectPath + "/" + groupPath + "/" + fileName

        let xcodeproj = try! XcodeProj(pathString: xcodeprojPath)
        let pbxproj = xcodeproj.pbxproj
        let rootGroup = try! pbxproj.rootGroup()!

        let groupPathComponents = groupPath.split(separator: "/").map(String.init)

        let group = findGroup(withPath: ArraySlice(groupPathComponents), rootGroup: rootGroup)

        do {
            try group.addFile(at: Path(filePath), sourceTree: .group, sourceRoot: Path(projectPath))
        } catch {
            print(error)
        }

        try! xcodeproj.write(path: Path(xcodeprojPath))
    }

    private func findGroup(withPath path: ArraySlice<String>, rootGroup: PBXGroup) -> PBXGroup {
        guard let firstLevel = path.first else {
            return rootGroup
        }

        for group in rootGroup.children {
            if let group = group as? PBXGroup, let groupPath = group.path, groupPath == firstLevel {
                return findGroup(withPath: path.dropFirst(), rootGroup: group)
            }
        }

        return rootGroup // TODO: Error handling
    }
}