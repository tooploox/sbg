import SBGCore

let manipulator = XcodeprojProjectManipulator()
//manipulator.addToXCodeProject(filePath: "TestConnector.swift", target: "Test")
manipulator.addFileToXCodeProject(groupPath: "TestApp/Connectors", fileName: "TestConnector.swift")