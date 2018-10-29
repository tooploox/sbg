//
// Created by Karol on 10/10/2018.
//

import Foundation
import xcodeproj
import PathKit

class XcodeprojProjectManipulator: ProjectManipulator {

    private let pathResolver: PathResolver

    init(pathResolver: PathResolver) {
        self.pathResolver = pathResolver
    }

    func addFileToXCodeProject(groupPath: String, fileName: String, xcodeprojFile: String, target targetName: String) throws {
        let filePath = pathResolver.createFinalPath(from: groupPath, name: fileName)
        let xcodeproj = try XcodeProj(pathString: xcodeprojFile)
        let pbxproj = xcodeproj.pbxproj

        let rootGroupOptional = try pbxproj.rootGroup()

        guard let rootGroup = rootGroupOptional else {
            throw ProjectManipulatorError.cannotFindRootGroup
        }

        let groupPathComponents = ArraySlice(groupPath.split(separator: "/").map(String.init))
        guard let group = findGroup(withPath: groupPathComponents, rootGroup: rootGroup) else {
            throw ProjectManipulatorError.cannotFindGroup(groupPath)
        }

        let fileReference = try group.addFile(at: Path(filePath), sourceRoot: Path(""))

        guard let target = pbxproj.targets(named: targetName).first else {
            throw ProjectManipulatorError.cannotFindTarget(targetName)
        }

        let buildPhaseOptional = try target.sourcesBuildPhase()
        guard let buildPhase = buildPhaseOptional else {
            throw ProjectManipulatorError.cannotGetSourcesBuildPhase
        }

        try buildPhase.add(file: fileReference)
        try xcodeproj.write(path: Path(xcodeprojFile))
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