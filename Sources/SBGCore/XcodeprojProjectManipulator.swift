//
// Created by Karol on 10/10/2018.
//

import Foundation
import xcodeproj
import PathKit

class XcodeprojProjectManipulator: ProjectManipulator {

    func addFileToXCodeProject(groupPath: String, fileName: String, xcodeprojFile: String, target targetName: String) -> Result<Void, ProjectManipulatorError> {
        let filePath = groupPath + "/" + fileName

        guard let xcodeproj = try? XcodeProj(pathString: xcodeprojFile) else {
            return .failure(.cannotOpenXcodeproj(xcodeprojFile))
        }

        let pbxproj = xcodeproj.pbxproj

        guard let rootGroup = (try? pbxproj.rootGroup()) as? PBXGroup else {
            return .failure(.cannotFindRootGroup)
        }

        let groupPathComponents = ArraySlice(groupPath.split(separator: "/").map(String.init))
        guard let group = findGroup(withPath: groupPathComponents, rootGroup: rootGroup) else {
            return .failure(.cannotFindGroup(groupPath))
        }

        guard let fileReference = try? group.addFile(at: Path(filePath), sourceRoot: Path("")) else {
            return .failure(.cannotAddFileToGroup(fileName, group.path!))
        }

        guard let target = pbxproj.targets(named: targetName).first else {
            return .failure(.cannotFindTarget(targetName))
        }

        guard let buildPhase = (try? target.sourcesBuildPhase()) as? PBXSourcesBuildPhase else {
            return .failure(.cannotGetSourcesBuildPhase)
        }

        guard let _ = try? buildPhase.add(file: fileReference) else {
            return .failure(.cannotAddFileToSourcesBuildPhase(fileName))
        }

        guard let _ = try? xcodeproj.write(path: Path(xcodeprojFile)) else {
            return .failure(.cannotWriteXcodeprojFile)
        }

        return .success(())
    }

    private func findGroup(withPath path: ArraySlice<String>, rootGroup: PBXGroup) -> PBXGroup? {
        guard let firstLevel = path.first else {
            return rootGroup
        }

        for group in rootGroup.children {
            if let group = group as? PBXGroup, let groupPath = group.path, groupPath == firstLevel {
                return findGroup(withPath: path.dropFirst(), rootGroup: group)
            }
        }

        return nil
    }
}