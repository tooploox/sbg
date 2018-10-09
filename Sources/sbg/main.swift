import Stencil
import xcodeproj

let loader = FileSystemLoader(paths: ["/Users/dawidmarkowski/Documents/Developer/Projects/sbg/"])
let environment = Environment(loader: loader, extensions: nil)

let application = Application(fileRenderer: environment)
let parameteres = ApplicationParameters(generatorName: "cleanui", invocationParameters: ["template_name": "template", "name": "Wladek"])

application.run(parameters: parameteres)
