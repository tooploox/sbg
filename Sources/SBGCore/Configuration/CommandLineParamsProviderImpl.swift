//
// Created by Karolina Samorek on 2018-10-29.
//

import Foundation

class CommandLineParamsProviderImpl: CommandLineParamsProvider {

    var parameters: [String] {
        return CommandLine.arguments
    }
}