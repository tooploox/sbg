//
//  FileRenderer.swift
//  sbg
//
//  Created by Dawid Markowski on 09/10/2018.
//

import Foundation
import Stencil

protocol FileRenderer {
    func renderTemplate(name: String, context: [String: Any]?) throws -> String
}

extension Environment: FileRenderer {}
