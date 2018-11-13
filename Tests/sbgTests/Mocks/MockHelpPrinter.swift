//
//  MockHelpPrinter.swift
//  SBGTests
//
//  Created by Dawid Markowski on 07/11/2018.
//

import Foundation
@testable import SBGCore

class MockHelpPrinter: HelpPrinter {
    
    private(set) var invocationCount = 0
    
    func printHelp() {
        invocationCount += 1
    }
}
