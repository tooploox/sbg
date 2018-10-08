import Stencil
import xcodeproj

let loader = FileSystemLoader(paths: ["/Users/dawidmarkowski/Documents/Developer/Projects/sbg/"])
let environment = Environment(loader: loader, extensions: nil)

let application = Application(fileRenderer: StencilFileRenderer(templateLoader: environment))
let parameteres = ApplicationParameters(generatorName: "cleanui", invocationParameters: [:])

application.run(parameters: parameteres)
