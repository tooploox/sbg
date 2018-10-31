//
// Created by Karol on 2018-10-26.
//

import Foundation

final class XcodeprojFileNameProviderImpl: XcodeprojFileNameProvider {

    func getXcodeprojFileName() throws -> String {
        return try FileManager.default
            .contentsOfDirectory(atPath: ".")
            .filter { $0.hasSuffix(".xcodeproj") }
            .first!
    }
}