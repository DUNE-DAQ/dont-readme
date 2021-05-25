# DUNE DAQ Software Documentation Home

There are four DUNE DAQ software packages which are used to aid
developers in creating packages designed for the DAQ itself:

To learn how to build an existing software package, read the [daq-buildtools documentation](packages/daq-buildtools/README.md)

To learn how to create a new package or modify the build of an existing one, read the [daq-cmake documentation](packages/daq-cmake/README.md)

To learn about the standard development workflow, read the [daq-release documentation](packages/daq-release/README.md), in particular [this page](https://dune-daq-sw.readthedocs.io/en/latest/packages/daq-release/development_workflow_gitflow/)

To learn about the C++ coding guidelines which DUNE DAQ package developers should follow, read [the styleguide](packages/styleguide/README.md)

--------------

For the other packages, please click on one of the links below. To learn how to edit a package's documentation, click [here](editing_package_documentation.md). Packages marked with a &#x2705; have completed documentation, &#x26A0; means the documentation is a work in progress, and &#x26D4; means documentation doesn't (yet) exist. 

### Core

&#x2705; [appfwk](packages/appfwk/README.md) _home of_ daq_application _and tools for writing DAQModules_

&#x26A0; [cmdlib](packages/cmdlib/README.md) _interfaces for commanded objects_

&#x2705; [ers](packages/ers/README.md) _fork of the ATLAS Error Reporting System_

&#x2705; [logging](packages/logging/README.md) _contains the functions DUNE DAQ packages use to output text_

### Readout

&#x2705; [dataformats](packages/dataformats/README.md) _raw data reinterpretation utilities_

&#x26A0; [readout](packages/readout/README.md) _upstream DAQ readout, DAQModules, CCM interface implementations_

### Control

&#x26A0; [minidaqapp](packages/minidaqapp/README.md) _application to read out Felix data and store it in HDF5 files on disk_

&#x2705; [nanorc](packages/nanorc/README.md) _Not ANOther Run Control_

&#x26D4; [rcif](packages/rcif/README.md) _run control related_

&#x2705; [restcmd](packages/restcmd/README.md) _HTTP REST backend based CommandFacility_

### Dataflow (logical)

&#x2705; [dfmessages](packages/dfmessages/README.md) _dataflow messages_

&#x2705; [dfmodules](packages/dfmodules/README.md) _dataflow applications_

&#x26D4; [trigemu](packages/trigemu/README.md) _trigger decision emulator for readout application tests_

### Dataflow (physical)

&#x2705; [ipm](packages/ipm/README.md) _message passing between processes_

&#x2705; [nwqueueadapters](packages/nwqueueadapters/README.md) _DAQModules that connect appfwk queues to IPM network connections_

&#x2705; [serialization](packages/serialization/README.md) _utilities for C++ object serialization/deserialization_

### Monitoring

&#x2705; [erses](packages/erses/README.md) _insert ERS messages into a searchable database_

&#x2705; [influxopmon](packages/influxopmon/README.md) _Influx database based plugin for operational monitoring_

&#x26A0; [opmonlib](packages/opmonlib/README.md) _operational monitoring library_

### Educational

&#x2705; [listrev](packages/listrev/README.md) _educational example of DAQModules for new developers_

------

_Mar-11-2021: For software coordinators only:_ [how to make edits to this webpage](how_to_make_edits.md)
