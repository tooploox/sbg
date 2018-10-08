//
//  StencilFileRenderer.swift
//  sbg
//
//  Created by Dawid Markowski on 08/10/2018.
//

import Foundation
import Stencil

class StencilFileRenderer: FileRenderer {
    
    private let templateLoader: TemplateLoader
    
    init(templateLoader: TemplateLoader) {
        self.templateLoader = templateLoader
    }
    
    func render(from template: String, parameters: [String: String]) throws -> String {
        let stencilTemplate = try templateLoader.loadTemplate(name: template)
        return try stencilTemplate.render(parameters)
    }
}


