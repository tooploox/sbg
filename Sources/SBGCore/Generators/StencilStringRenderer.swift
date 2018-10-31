//
// Created by Karol on 2018-10-26.
//

import Foundation
import Stencil

final class StencilStringRenderer: StringRenderer {

    func render(string: String, context: [String: String]) throws -> String {
        return try Environment().renderTemplate(string: string, context: context)
    }
}