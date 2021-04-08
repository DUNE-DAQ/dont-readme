# Compiling and running


**_JCF, Mar-2-2021: You don't want to be here unless you're actively developing the build system (daq-buildtools) itself - as opposed to a DUNE DAQ package which is designed to work within the build system. Instead, you want to follow the instructions for building with the most recent frozen daq-buildtools release: https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.2.0._**

# Getting started

## System requirements

To get set up, you'll need access to the ups product area /cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products, as is the case, e.g., on the lxplus machines at CERN. 

## Setup `daq-buildtools`
`daq-buildtools` is a simple package that provides environment and building utilities for the DAQ Suite. 
Each cloned daq-buildtools can serve as many work areas as the developer wishes. 

The repository can simply be cloned via
```bash
git clone https://github.com/DUNE-DAQ/daq-buildtools.git -b develop
```
This step doesn't have to be run more than once per daq-buildtools version. 

The `dbt` setup script has to be sourced to make the `dbt` scripts available in the commandline regardless of the current work directory. Run:
```bash
source daq-buildtools/dbt-setup-env.sh
```
..and you'll see something like:
```
Added /your/path/to/daq-buildtools/bin to PATH
Added /your/path/to/daq-buildtools/scripts to PATH
DBT setuptools loaded
```
After this step `daq-buildtools` scripts and aliases will be accessible from your commandline regardless of the current working directory. They include `dbt-create.sh`, `dbt-build.sh` and the aliases `dbt-setup-build-environment` and `dbt-setup-runtime-environment` which are used in the following sections.

Each time that you want to work with a DUNE DAQ development area in a fresh Linux shell, you'll need to set up `daq-buildtools` using the `dbt-setup-env.sh` script, as described above.

## Creating a development area (AKA work area)

Once you've sourced `dbt-setup-env.sh`, you're now ready to create a development area. Create an empty directory (give it any name, but we'll refer to it as "MyTopDir" on this wiki) and 'cd' into it. Then run:
```sh
dbt-create.sh <release>  # dunedaq-v2.3.0 is the most recent release as of Mar-2-2021
```
which will set up an area to place the repos you wish to build.

```txt
MyTopDir
├── build
├── dbt-pyvenv
├── dbt-settings
├── log
└── sourcecode
    ├── CMakeLists.txt
    └── dbt-build-order.cmake
```

For the purposes of instruction, let's build the `listrev` package. Downloading it is simple:
```
cd sourcecode
git clone https://github.com/DUNE-DAQ/listrev.git -b v2.1.1 
cd ..
```
Note the assumption above is that you aren't developing listrev; if you were, then you'd want to replace `-b v2.1.1` with `-b <branch you want to work on>`.

## Adding extra UPS products and product pools

Sometimes it is necessary to tweak the baseline list of UPS products or even UPS product pools to add extra dependencies. 
This can be easily done by editing the `dbt-settings` file copied over from daq-buildtools by `dbt-create.sh` and adding the new entries to `dune_products_dirs`  and `dune_daqpackages` as needed. See "/example/of/additional/user/declared/product/pool" and "package_declared_by_user v1_2_3 e19:prof" in the example of an edited `dbt-settings` file, below:

```bash
dune_products_dirs=(
    "/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/releases/dunedaq-v2.3.0/externals"
    "/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/releases/dunedaq-v2.3.0/packages"
    "/example/of/additional/user/declared/product/pool" 
    #"/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products"
    #"/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products_dev"
)

dune_systems=(
    "gcc v8_2_0"
    "python v3_8_3b"
    )

dune_devtools=(
    "cmake v3_17_2"
    "gdb v9_2"
    "ninja v1_10_0"
    )

dune_externals=(
    "cetlib v3_11_01 e19:prof"
    "TRACE v3_16_02"
    "folly v2020_05_25a e19:prof"
    "nlohmann_json v3_9_0c e19:prof"
    "pistache v2020_10_07 e19:prof"
    "highfive v2_2_2b e19:prof"
    "zmq v4_3_1c e19:prof"
    "cppzmq v4_3_0 e19:prof"
    "msgpack_c v3_3_0 e19:prof"
    )

dune_daqpackages=(
    # Note: "daq_cmake" with underscore is the UPS product name.
    # One can use either "daq-cmake" or "daq_cmake" in this file.
    "daq-cmake v1_3_1 e19:prof"
    "appfwk v2_2_0 e19:prof"
    "cmdlib v1_1_1 e19:prof"
    "restcmd v1_1_0 e19:prof"
    "listrev v2_1_1 e19:prof"
    "ers v1_1_0 e19:prof"
    "logging v1_0_1 e19:prof"
    "opmonlib v1_0_0 e19:prof"
    "rcif v1_0_1 e19:prof"
    "package_declared_by_user v1_2_3 e19:prof"
)
```
As the names suggest, `dune_products_dirs` contains the list of UPS product pools and `dune_daqpackages` contains a list of UPS products sourced by `dbt-setup-build-environment` (described below). If you've already sourced `dbt-setup-build-environment` before editing the `dbt-settings` file, you'll need to log into a fresh shell and source `dbt-setup-env.sh` and `dbt-setup-build-environment` again. 


## Compiling
We're about to build and install the `listrev` package. (&#x1F534; Note: if you are working with other packages, have a look at the [Working with more repos](#working-with-more-repos) subsection before running the following build command.) By default, the scripts will create a subdirectory of MyTopDir called `./install `and install any packages you build off your repos there. If you wish to install them in another location, you'll want to set the environment variable `DBT_INSTALL_DIR` to the desired installation path after the `dbt-setup-build-environment` command described below, but before the `dbt-build.sh` command. 

Now, do the following:
```sh
dbt-setup-build-environment  # Only needs to be done once in a given shell
dbt-build.sh --install
```
...and this will build `listrev` in the local `./build` subdirectory and then install it as a package either in the local `./install` subdirectory or in whatever you pointed `DBT_INSTALL_DIR` to. 

### Working with more repos
To work with more repos, add them to the `./sourcecode` subdirectory as we did with listrev. Be aware, though: if you're developing a new repo which itself depends on another new repo, `daq-buildtools` may not already know about this dependency. "New" in this context means "not found on https://github.com/DUNE-DAQ as of ~Mar-2-2021". If this is the case, you have one of two options:


* (Recommended) Add the names of your new packages to the `build_order` list found in `./sourcecode/dbt-build-order.cmake`, placing them in the list in the relative order in which you want them to be built. 

* First clone, build and install your new base repo, and THEN clone, build and install your other new repo which depends on your new base repo. 

`dbt-build.sh` will by default skip CMake's config+generate stages and go straight to the build stage _unless_ either the `CMakeCache.txt` file isn't found in `./build` or you've just added a new repo to `./sourcecode`. If you want to remove all the contents of `./build` and run config+generate+build, all you need to do is add the `--clean` option, i.e.
```
dbt-build.sh --clean --install
```
And if, after the build, you want to run the unit tests, just add the `--unittest` option. Note that it can be used with or without `--clean`, so, e.g.:
```
dbt-build.sh --clean --install --unittest  # Blow away the contents of ./build, run config+generate+build, and then run the unit tests
```
..where in the above case, you blow away the contents of `./build`,  run config+generate+build, install the result in `./install` and then run the unit tests. Be aware that for many packages, unit tests will only (fully) work if you've also set up their runtime environment; how to do this is described below in the "Running" section of this document. 

To check for deviations from the coding rules described in the [DUNE C++ Style Guide](https://github.com/DUNE-DAQ/styleguide/blob/develop/dune-daq-cppguide.md), run with the `--lint` option:
```
dbt-build.sh --lint
```
...though be aware that some guideline violations (e.g., having a function which tries to do unrelated things) can't be picked up by the automated linter. 

Note that unlike the other options to `dbt-build.sh`, `--lint` and `--unittest` are both capable of taking an optional argument, which is the name of a specific repo in your work area which you'd like to either lint or run unit tests for. This can be useful if you're focusing on developing one of several repos in your work area. E.g., `dbt-build.sh --lint <repo you're working on>`.

If you want to see verbose output from the compiler, all you need to do is add the `--verbose` option:
```
dbt-build.sh --verbose 
```

You can see all the options listed if you run the script with the `--help` command, i.e.
```
dbt-build.sh --help
```
Finally, note that both the output of your builds and your unit tests are logged to files in the `./log` subdirectory. These files may have ASCII color codes which make them difficult to read with some tools; `more` or `cat`, however, will display the colors and not the codes themselves. 

</details>

## Running

In order to run the applications built during the above procedure, the system needs to be instructed on where to look for the libraries that can be used to instantiate objects. This is handled by the `dbt-setup-runtime-environment` script which was placed in MyTopDir when you ran dbt-create.sh; all you need to do is the following:
```
dbt-setup-runtime-environment
```

Note that if you add a new repo to your development area, after building your new code you'll need to run the script again. 

Once the runtime environment is set, just run the application you need. listrev, however, has no applications; it's just a DAQ module plugin which get added to CET_PLUGIN_PATH.  

We're now going to go through a demo in which we'll use a DAQ module from listrev called RandomDataListGenerator to generate vectors of random numbers and then reverse them with listrev's ListReverser module.  

One of the packages that's part of the standard DUNE DAQ package suite which gets set up when you run `dbt-setup-build-environment` is cmdlib. This package comes with a basic implementation that is capable of sending available command objects from a pre-loaded file, by typing their command IDs to standard input. This command facility is useful for local, test oriented use-cases. In the same runtime area, launch the application like this:
```
daq_application -n <some name for the application instance> -c stdin://sourcecode/listrev/test/list-reversal-app.json
```
and (keeping in mind that you'll want to scroll the contents below horizontally to see the full output) you'll see something like
```
2021-Mar-02 13:09:35,342 LOG [stdinCommandFacility::stdinCommandFacility(...) at /scratch/workdir0/sourcecode/cmdlib/plugins/stdinCommandFacility.cpp:55] Loading commands from file: sourcecode/listrev/test/list-reversal-app.json
2021-Mar-02 13:09:35,342 LOG [stdinCommandFacility::run(...) at /scratch/workdir0/sourcecode/cmdlib/plugins/stdinCommandFacility.cpp:83] Available commands: | init | conf | start | stop
```
What you want to do first is type `init`. Next, type `conf` to execute the configuration, and then `start` to begin the actual process of moving vectors between the two modules. You should see output like the following:
```log
2021-Mar-02 13:12:40,291 DEBUG_63 [dunedaq::listrev::RandomDataListGenerator::do_work(...) at /scratch/workdir0/sourcecode/listrev/plugins/RandomDataListGenerator.cpp:163] Generated list #3 with contents {363, 28, 691, 60, 764} and size 5.  DAQModule: rdlg
2021-Mar-02 13:12:40,291 DEBUG_63 [dunedaq::listrev::ListReverser::do_work(...) at /scratch/workdir0/sourcecode/listrev/plugins/ListReverser.cpp:134] Reversed list #3, new contents {764, 60, 691, 28, 363} and size 5.  DAQModule: lr
2021-Mar-02 13:12:40,291 DEBUG_63 [dunedaq::listrev::ReversedListValidator::do_work(...) at /scratch/workdir0/sourcecode/listrev/plugins/ReversedListValidator.cpp:159] Validating list #3, original contents {363, 28, 691, 60, 764} and reversed contents {764, 60, 691, 28, 363}.  DAQModule: rlv
```
To stop this, type the `stop` command. Ctrl-c will exit you out. 

For a more realistic use-case where you can send commands to the application from other services and applications, the [restcmd](https://github.com/DUNE-DAQ/restcmd) package provides a command handling implementation through HTTP. To use this plugin, we call `daq_application` in the following manner:
```sh
daq_application -n <some name for the application instance> --commandFacility rest://localhost:12345
```
To control it, let's open up a second terminal, set up the daq-buildtools' dbt-setup-env.sh script as you did in the first terminal, and start sending daq_application commands:
```sh
cd MyTopDir
dbt-setup-runtime-environment
curl -O https://raw.githubusercontent.com/DUNE-DAQ/restcmd/v1.1.0/scripts/send-restcmd.py
python ./send-restcmd.py --interactive --file ./sourcecode/listrev/test/list-reversal-app.json
```
You'll now see
```txt
Target url: http://localhost:12345/command
This is a list of commands.
Interactive mode. Type the ID of the next command to send, or type 'end' to finish.

Available commands: [u'init', u'conf', u'start', u'stop']
Press enter a command to send next: 
```
And you can again type `init`, etc. However, unlike previously, now you'll want to look in the other terminal running daq_application to see it responding to the commands. As before, Ctrl-c will exit you out of these applications. 

<details><summary>daq_application Command Line Arguments</summary>

Use `daq_application --help` to see all of the possible options:
```sh
bash$ daq_application --help
daq_application known arguments (additional arguments will be stored and passed on):
  -c [ --commandFacility ] arg CommandFacility URI
  -h [ --help ]                produce help message
```

</details>


<details><summary>Some additional information</summary>

### TRACE Messages

To enable the sending of TRACE messages to a memory buffer, you can set one of several TRACE environmental variables _before_ running `appfwk/apps/simple_test_app`.  One example is to use a command like `export TRACE_NAME=TRACE`.  (For more details, please see the [TRACE package documentation](https://cdcvs.fnal.gov/redmine/projects/trace/wiki/Wiki). For example, the [Circular Memory Buffer](https://cdcvs.fnal.gov/redmine/projects/trace/wiki/Circular_Memory_Buffer) section in the TRACE Quick Start talks about the env vars that you can use to enable tracing.)

To view the TRACE messages in the memory buffer, you can use the following additional steps:


* [if not done already] `export SPACK_ROOT=<your spack root> ; source $SPACK_ROOT/setup-env.sh`

* [if not done already] `spack load trace`

* `trace_cntl show` or `trace_cntl show | trace_delta -ct 1` (The latter displays the timestamps in human-readable format.  Note that the messages are listed in reverse chronological order in both cases.)

</details>

## Next Step


* [Creating a new package](Instructions-for-creating-a-new-package .md)
-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: Eric Flumerfelt_

_Date: Wed Apr 7 11:56:00 2021 -0500_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/appfwk/issues](https://github.com/DUNE-DAQ/appfwk/issues)_
</font>