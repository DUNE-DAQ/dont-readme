# CmakeFunctions
# cmake daq functions

## daq_setup_environment:
Usage:  

```
daq_setup_environment()
```

This macro should be called immediately after this DAQ module is
included in your DUNE DAQ project's CMakeLists.txt file; it ensures
that DUNE DAQ projects all have a common build environment. It takes 
no arguments. 

## daq_codegen:
Usage:  
```
daq_codegen( <schema filename> [TEST] [DEP_PKGS <package 1> ...] [MODEL <model filename>] 
             [TEMPLATES <template filename1> ...] )
```

`daq_codegen` takes the schema files (without path) and uses `moo` to generate C++ headers from the templates.

Arguments:
   `<schema filenames>`: The list of schema files to process from `<package>/schema/<package>`. 
   Each schema file will applied to each template (specified by the TEMPLATE argument).
   Each schema/template pair will generate a code file in 
      `build/<package>/codegen/include/<schema basename>/<template basename>`
   e.g. `myschema.jsonnet` (from my_pkg) + `your_pkg/YourStruct.hpp.j2` will result in
       `build/codegen/my_pkg/my_schema/YourStruct.hpp`

   `TEST`: If the code is meant for an entity in the package's `test/` subdirectory, "TEST"
     should be passed as an argument, and the schema file's path will be assumed to be
     "test/schema/" rather than merely "schema/". 

   `DEP_PKGS`: If schema, template or model files depend on files provided by other DAQ packages,
     the "DEP_PKGS" argument must contain the list of packages.

   `MODEL`: The MODEL argument is # optional; if no model file name is explicitly provided,
     omodel.jsonnet from the moo package itself is used.

   `TEMPLATES`: The list of templates to use. This is a mandatory argument. The template file format is 
       `<template package>/<template name>.j2`
     If `<template package>` is omitted, the template is expected to be made available by moo.

## daq_add_library:
Usage:  
```
daq_add_library( <file | glob expression 1> ... [LINK_LIBRARIES <lib1> ...])
```

`daq_add_library` is designed to produce the main library provided by
a project for its dependencies to link in. It will compile a group
of files defined by a set of one or more individual filenames and/or
glob expressions, and link against the libraries listed after
`LINK_LIBRARIE`S. The set of files is assumed to be in the `src/`
subdirectory of the project.

As an example, 
`daq_add_library(MyProj.cpp *Utils.cpp LINK_LIBRARIES ers::ers)` 
will create a library off of `src/MyProj.cpp` and any file in `src/`
ending in "Utils.cpp", and links against the ERS (Error Reporting
System) library

## daq_add_plugin:
Usage:  
```
daq_add_plugin( <plugin name> <plugin type> [TEST] [LINK_LIBRARIES <lib1> ...])
```

`daq_add_plugin` will build a plugin of type <plugin type> with the
user-defined name `<plugin name>`. It will expect that there's a file
with the name `<plugin name>.cpp` located either in the `plugins/`
subdirectory of the project (if the `TEST` option isn't used) or in
the `test/plugins/` subdirectory of the project (if it is). Note that if the
plugin is deemed a "TEST" plugin, it's not installed as the
assumption is that it's meant for developer testing. Like
daq_add_library, daq_add_plugin can be provided a list of libraries
to link against, following the `LINK_LIBRARIES` argument. 

Your plugin will look in `include/` for your project's public headers
and `src/` for its private headers. Additionally, if it's a "TEST"
plugin, it will look in `test/src/`.

## daq_add_application

Usage:  
```
daq_add_application(<application name> <file | glob expression> ... [TEST] [LINK_LIBRARIES <lib1> ...])
```

This function is designed to build a standalone application in your
project. Its first argument is simply the desired name of the
executable, followed by a list of filenames and/or file glob
expressions meant to build the executable. It expects the filenames
to be either in the `apps/` subdirectory of the project, or, if the
"TEST" option is chosen, the `test/apps/` subdirectory. Note that if
the plugin is deemed a "TEST" plugin, it's not installed as the
assumption is that it's meant for developer testing. Like
daq_add_library, daq_add_application can be provided a list of
libraries to link against, following the `LINK_LIBRARIES` token.

## daq_add_unit_test
Usage:  
```
daq_add_unit_test(<unit test name> [LINK_LIBRARIES <lib1> ...])
```

This function, when given the extension-free name of a unit test
sourcefile in `unittest/`, will handle the needed boost functionality
to build the unit test, as well as provide other support (CTest,
etc.). Like daq_add_library, daq_add_unit_test can be provided a
list of libraries to link against, following the `LINK_LIBRARIES`
token.

## daq_install
Usage:  
```
daq_install()
```

This function should be called at the bottom of a project's
`CMakeLists.txt` file in order to install the project's targets. It takes no
arguments.
