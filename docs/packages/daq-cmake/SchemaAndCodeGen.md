# SchemaAndCodeGen
# Schema and Code generation

`daq-cmake` supports for schema distribution and code generation with [moo](https://github.com/brettviren/moo/)



1. Schemas (jsonnet), models (jsonnet) and templates (jinjia) in the `schema/<package name>` folder are automatically copied to the installation driector and into ups products eventually.


1. The `daq_codegen` cmake function provides a simpliefied interface to `moo render` to generate C++ files from jinjia templates. It provides a mechanism to easily import schemas, templates or models from other packages and implements an out-of-date dependency check.

## Schema files

`daq-cmake` handles schemas in a similar fashion to C++ headers. Where header files are located according to the namespace of the class they declare (e.g. `mypkg::MyClass` in `include/mypkg/MyClass.hpp`, schemas location in the package is determined by the schema path (e.g. `mypkg.myschema` in `schema/mypkg/myschema.jsonnet`). In both cases the package name is integral part of the namespace/path to ensure uniqueness of the declared entities.

As an example, below is shown the organizarion of the `appfwk/schema` folder:

```txt
appfwk/
├── apps
├── cmake
├── CMakeLists.txt
├── doc
├── include
├── python
├── README.md
├── schema
│   ├── appfwk
│   │   ├── appinfo.jsonnet
│   │   ├── app.jsonnet
│   │   └── cmd.jsonnet
│   ├── README.md
│   └── README.org
├── src
├── test
└── unittest
```

`cmd.jsonnet` declares `dunedaq.appfwk.cmd` schema structures with the following statement

```jsonnet
local s = moo.oschema.schema("dunedaq.appfwk.cmd");
```

The same applies to `app.jsonnet` and `appinfo.jsonnet` for `dunedaq.appfwk.app` and `dunedaq.appfwk.appinfo` respectively.

The matching between the schema file name/path and the jsonnet namespace is essential for code generaton with `daq-cmake`. A mismatch between the two will result in empty generated files in most of the cases.

## Code generation with `daq_codegen`

`daq-cmake` provides the `daq_codegen` function to convert schema files to C++ entitites based on a model and a template. The function arguments are
```
daq_codegen( <schema files> [TEST] [DEP_PKGS <package 1> ...] [MODEL <model filename>] 
             [TEMPLATES <template filename1> ...] )
```
and the full reference is available [here](CmakeFunctions.md).  
These are its key features:

- `daq_codegen` assumes that schema files are located in `schema/mypkg`
- One or more template files must be defined.
- The path of the generated C++ headers is a combination of the schema path and the template name:  
  `mypkg.myschema` applied to `MyTemplate.hpp.j2` will result in `include/mypkg/myschema/MyTemplate.hpp.j2`.  
  **NOTE** The schema filename is converted to lowercase
- Templates are specified as `<template package>/<template name .j2>`. If `<template package>` is omitted, a moo template will be assumed. Othewise `daq_codegen` will search for the template file in `<template package>/<template name .j2>`


## Upgrade guide

### Schema files



1. Create the `schema/<package>` directory and move existing schema files in there


2. Rename the schema file according to the schema path

e.g. `schema/appfwk-cmd-schema.jsonnet` to `schema/appfwk/cmd.jsonnet`

### CMakeList.txt



1. Remove `SCHEMA` from `daq_add_plugin(...)` if it's used


2. Add `daq_codegen(...)` with appropriate parameters. In most of the cases the following should work
   ```
   daq_codegen(*.jsonnet TEMPLATES Struct.hpp.j2 Nljs.hpp.j2)
   ```

### config.cmake.in



1. Add the following lines to `<pkg>Config.cmake.in`:

   ```diff
   add_library(@PROJECT_NAME@::@PROJECT_NAME@ ALIAS @PROJECT_NAME@)
   
   + get_filename_component(@PROJECT_NAME@_DAQSHARE "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)
   
   else()
   ```
   
   and
   
   ```diff
   include(${targets_file})
   
   + set(@PROJECT_NAME@_DAQSHARE "${CMAKE_CURRENT_LIST_DIR}/../../../share")
   
   endif()
   ```



