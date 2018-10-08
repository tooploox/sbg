//
//  TemplateLoader.swift
//  sbg
//
//  Created by Dawid Markowski on 08/10/2018.
//

import Foundation
import Stencil

protocol TemplateLoader {
    func loadTemplate(name: String) throws -> Template
}

extension Environment: TemplateLoader {}
