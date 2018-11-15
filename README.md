Swift boilerplate generator
======================================

Swift boilerplate generator is a command line tool which helps reducing unnecessary work of creating over and over files which follow some scheme.

- [Installation](#installation)
- [Usage](#usage)
  - [Init](#Init)
  - [Command Line](#Command Line)
  - [SBGConfig](#SBGConfig)
  - [Generators](#Generators)
  - [Templates](#Templates)

## Installation

### Homebrew

[Homebrew](https://brew.sh) is a package manager for MacOS. You can install it with the following command:

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

When you have homebrew you can install SBG just by running:

```bash
$ brew install tooploox/sbg/sbg
```

## Usage

- ### Init

  SBG requires specific structure of catalogs and files. To create them go to the root of your project and simply run the command:

  ```bash
  $ SBG init
  ```

  It will create `.sbg` catalog with `SBGConfig` file inside. Under `.sbg` it also creates catalogs `templates` and `generators` with example files inside.

- ### Command Line

  Usage of SBG is pretty simple. It has only 2 commands. One described above and second one is running generator. Syntax is:

  ```bash
  $ SBG generator_name --parameter_one value_one --parameter_two value_two
  ```

  where `generator_name` is a name of your generator to run and then you have list of parameters. This list can be endless and you can provide any parameters you want.

- ### SBGConfig

  It is a JSON format file. You can place there any parameters and values you want. It can be empty but then you have to provide parameters and values through console command. All parameters will be searched in your generator and template files and filled up with corresponding values so keep in mind that name of parameters must match. Parameters specified in command line have priority over those from `SBGConfig`.

- ### Generators

  This is JSON format file which describes what files you want to generate. It contains generator's name and list of steps to follow. Every step consists of name of template file, output file name, group and target where file should be added. Please remember that name of this file should match value of the `name` parameter inside.

- ### Templates

  We use [Stencil](https://github.com/stencilproject/Stencil) as out template engine. You can read about their syntax on their [site](http://stencil.fuller.li/en/latest/templates.html). Those files represent how generated files will look like. Generator in every step takes one template, fills corresponding variable with given value and adds this file to proper group and target.
