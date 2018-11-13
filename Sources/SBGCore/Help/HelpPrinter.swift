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
    
    private let helpContentProvider: HelpContentProvider
    
    init(helpContentProvider: HelpContentProvider) {
        self.helpContentProvider = helpContentProvider
    }
    
    func printHelp() {
        print(helpContentProvider.generalHelp)
    }
}
