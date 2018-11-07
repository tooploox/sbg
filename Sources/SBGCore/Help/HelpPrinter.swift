//
//  HelpProvider.swift
//  sbg
//
//  Created by Dawid Markowski on 06/11/2018.
//

import Foundation

protocol HelpPrinter {
    func printHelp()
}

final class HelpPrinterImpl: HelpPrinter {
    
    private let helpTextsProvider: HelpTextsProvider
    
    init(helpTextsProvider: HelpTextsProvider) {
        self.helpTextsProvider = helpTextsProvider
    }
    
    func printHelp() {
        print(helpTextsProvider.generalHelp)
    }
}
