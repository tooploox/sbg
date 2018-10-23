//
// Created by Karol on 23/10/2018.
//

import Foundation

struct Generator: Codable, Equatable {

    let name: String
    let steps: [Step]
}

struct Step: Codable, Equatable {

    let template: String
    let fileName: String
    let group: String
    let target: String
}