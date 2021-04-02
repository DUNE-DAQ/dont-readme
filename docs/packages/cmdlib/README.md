# cmdlib README
# cmdlib - Interfaces for commanded objects
Details about commands and commanded object can be found under the [User's Guide](doc/UserGuide.md).

### Building and running examples:


* create a software work area
  * see https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.2.0

* those instructions should already help you to clone cmdlib to the right directory

* build the software according to the instructions
  * `dbt-setup-build-environment`
  * `dbt-build.sh --clean --install`

* you can run some examples in another shell
  * `dbt-setup-runtime-environment`
  * `cmdlib_test_dummy_app`
  * `cmdlib_test_stdin_app`

### Using the stdinCommandFacility
There is a really simple and basic implementation that comes with the package.
The stdinCommandFacility reads the available commands from a file, then one can
execute these command by typing their IDs on stdin:

    daq_application -c stdin://sourcecode/appfwk/schema/fdpc-job.json

![Demo](https://cernbox.cern.ch/index.php/s/BxvvU0PlPuyHjla/download)
