//
// Created by Karolina Samorek on 2018-10-31.
//

import Foundation

final class DemoFilesContentProvider: FilesContentProvider {

    private(set) var sbgConfigFileContent: String = """
                                                    {
                                                        "main_target": "your_project_main_target",
                                                        "connectors_path": "your_project_name/Connectors",
                                                        "presenters_path": "your_project_name/Presenters",
                                                        "view_controllers_path": "your_project_name/Controllers"
                                                    }
                                                    """

    private(set) var templatesFiles: [String: String] = [
        "connector.stencil": """
                             import UIKit

                             class {{module_name}}Connector: {{module_name}}Routable {

                                 func connect() -> UIViewController {
                                     let presenter = {{module_name}}Presenter(router: self)
                                     let viewController = {{module_name}}ViewController(presenter: presenter)
                                     presenter.view = viewController

                                     return viewController
                                 }
                             }
                             """,
        "presenter.stencil": """
                             import Foundation

                             protocol {{module_name}}View: class {

                             }

                             protocol {{module_name}}Routable {

                             }

                             final class {{module_name}}Presenter {

                                 weak var view: {{module_name}}View?

                                 private let router: {{module_name}}Routable

                                 init(router: {{module_name}}Routable) {
                                    self.router = router
                                 }

                             }
                             """,
        "view_controller.stencil": """
                                   import UIKit

                                   class {{module_name}}ViewController: ViewController, {{module_name}}View {

                                       private let presenter: {{module_name}}Presenter

                                       init(presenter: {{module_name}}Presenter) {
                                           self.presenter = presenter
                                           super.init(nibName: nil, bundle: nil)
                                       }

                                       required init?(coder aDecoder: NSCoder) {
                                           fatalError("init coder not implemented")
                                       }
                                   }
                                   """
    ]

    private(set) var generatorsFiles: [String: String] = [
        "clean_module.json": """
                             {
                                 "name": "clean_module",
                                 "steps": [
                                     {
                                         "template": "connector.stencil",
                                         "file_name": "{{module_name}}Connector.swift",
                                         "group": "{{connectors_path}}",
                                         "target": "{{main_target}}"
                                     },
                                     {
                                         "template": "presenter.stencil",
                                         "file_name": "{{module_name}}Presenter.swift",
                                         "group": "{{presenters_path}}",
                                         "target": "{{main_target}}"
                                     },
                                     {
                                         "template": "view_controller.stencil",
                                         "file_name": "{{module_name}}ViewController.swift",
                                         "group": "{{view_controllers_path}}",
                                         "target": "{{main_target}}"
                                     }
                                 ]
                             }
                             """
    ]
}
