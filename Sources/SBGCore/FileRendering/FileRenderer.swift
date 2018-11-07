//
//  FileRenderer.swift
//  sbg
//
//  Created by Dawid Markowski on 09/10/2018.
//

import Stencil

final class StencilFileRenderer: FileRenderer {
    func renderTemplate(name: String, context: [String: Any]?) throws -> String {
        return try Environment(loader: FileSystemLoader(paths: ["."])).renderTemplate(name: name, context: context)
    }
}
