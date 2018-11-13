//
//  HelpTextsProvider.swift
//  SBGCore
//
//  Created by Dawid Markowski on 07/11/2018.
//

import Foundation

protocol HelpContentProvider {
    var generalHelp: String { get }
}

final class HelpContentProviderImpl: HelpContentProvider {
    
    private(set) var generalHelp: String = """
                                           Usage:
                                             SBG init  Initializes necessary structure, creates templates and generators folders and SBGConfig file, it also provides example generator which contains 3 steps based on 3 created templates for connector, presenter and viewcontroller files
                                             SBG <generator_name> [parameters]  Generates files according to specified generator and parameters. As parameters you can pass anything you want. Command line parameters have priority over those specified in SBGConfig. You can list them indefinitely. Syntax is --parameter_name value_for_preceding_parameter. Remember to update parameters names in your generators and templates.

                                           For more informations check https://github.com/tooploox/sbg
                                           """
}
