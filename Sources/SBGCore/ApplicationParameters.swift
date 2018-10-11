//
// Created by Karol on 08/10/2018.
//

import Foundation

struct ApplicationParameters {
    let generatorName: String
    let generatorParameters: [String: String]
    
    init(generatorName: String, generatorParameters: [String: String]) {
        self.generatorName = generatorName
        self.generatorParameters = generatorParameters
    }
    
    init(_ commandLineParameters: [String]) {
        let parameters = ApplicationParameters.convert(commandLineParameters)
        
        generatorName = parameters["--name"] ?? ""
        generatorParameters = parameters
    }
    
    private static func convert(_ commandLineParameters: [String]) -> [String : String] {
        guard !commandLineParameters.isEmpty else { return [:] }
        
        var dictionary = [String: String]()
        _ = stride(from: 0, to: commandLineParameters.count, by: 2).map { index in
            dictionary[commandLineParameters[index]] = commandLineParameters[index + 1]
        }
        
        return dictionary
    }
}
