//
// Created by Karolina Samorek on 2018-10-29.
//

import Foundation

final class CommandLineParamsProviderImpl: CommandLineParamsProvider {

    var parameters: [String] {
        return CommandLine.arguments
    }
}