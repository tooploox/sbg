//
//  HelpTextsProvider.swift
//  SBGCore
//
//  Created by Dawid Markowski on 07/11/2018.
//

import Foundation

protocol HelpTextsProvider {
    var generalHelp: String { get }
}

final class HelpTextsProviderImpl: HelpTextsProvider {
    
    private(set) var generalHelp: String = """
                                           Usage:
                                             SBG init  Initializes necessary structure, creates templates and generators folders and SBGConfig file
                                             SBG <generator_name> [options]  Generates files according to specified generator and options
                                           """
}
