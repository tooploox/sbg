//
// Created by Karolina Samorek on 2018-10-31.
//

import Foundation

final class DemoFilesContentProvider: FilesContentProvider {

    private(set) var sbgConfigFileContent: String = """
                                                    {
                                                        "main_target": "Your project target",
                                                        "connectors_path": "Your project name/Connectors",
                                                        "presenters_path": "Your project name/Presenters",
                                                        "view_controllers_path": "Your project name/Controllers"
                                                    }
                                                    """

    private(set) var templatesFiles: [String: String] = [
        "connector.stencil": """

                             """,
        "presenter.stencil": """

                             """,
        "view_controller.stencil": """

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