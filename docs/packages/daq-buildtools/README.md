
# DUNE DAQ Buildtools 

`daq-buildtools` is the toolset to simplify the development of DUNE DAQ packages. It provides environment and building utilities for the DAQ Suite.

## System requirements

To get set up, you'll need access to the ups product area `/cvmfs/dunedaq.opensciencegrid.org/products`, as is the case, e.g., on the lxplus machines at CERN. 
<a name="Setup_of_daq-buildtools"></a>
## Setup of `daq-buildtools`

Simply do:

```bash
source /cvmfs/dunedaq.opensciencegrid.org/setup_dunedaq.sh
setup_dbt dunedaq-v2.6.0 # "dunedaq-v2.6.0" can be replaced with any other tags of daq-buildtools
```

Then you'll see something like:
```
Added /your/path/to/daq-buildtools/bin to PATH
Added /your/path/to/daq-buildtools/scripts to PATH
DBT setuptools loaded
```
If you type `dbt-` followed by the `<tab>` key you'll see a listing of available commands, which include `dbt-create.sh`, `dbt-build.sh`, and `dbt-workarea-env`. These are all described in the following sections.

Each time that you want to work with a DUNE DAQ work area in a fresh Linux shell, you'll need to set up daq-buildtools, either by repeating the method above, or by `cd`'ing into your work area and sourcing the link file named `dbt-env.sh`. Work areas are described next. 

<a name="Creating_a_work_area"></a>
## Creating a work area

Find a directory in which you want your work area to be a subdirectory (home directories are a popular choice) and `cd` into that directory. Then think of a good name for the work area (give it any name, but we'll refer to it as "MyTopDir" on this wiki). Run:
```sh
dbt-create.sh <release> <name of work area subdirectory> # dunedaq-v2.6.0 is the most recent frozen release as of May-28-2020
cd <name of work area subdirectory>
```
The second step's important: remember to `cd` into the subdirectory you just created after `dbt-create.sh` finishes running. 

The structure of your work area will look like the following:
```txt
MyTopDir
├── build
├── dbt-pyvenv
├── dbt-settings
├── dbt-env.sh -> /path/to/daq-buildtools/env.sh
├── log
└── sourcecode
    ├── CMakeLists.txt
    └── dbt-build-order.cmake
```

<a name="Cloning_and_building"></a>
## Cloning and building a package repo

### The basics

For the purposes of instruction, let's build the `listrev` package. Downloading it is simple:
```
cd sourcecode
git clone https://github.com/DUNE-DAQ/listrev.git -b dunedaq-v2.6.0 
cd ..
```
Note the assumption above is that you aren't developing listrev; if you were, then you'd want to replace `-b dunedaq-v2.6.0` with `-b <branch you want to work on>`.

We're about to build and install the `listrev` package. (&#x1F534; Note: if you are working with other packages, have a look at the [Working with more repos](#working-with-more-repos) subsection before running the following build command.) By default, the scripts will create a subdirectory of MyTopDir called `./install ` and install any packages you build off your repos there. If you wish to install them in another location, you'll want to set the environment variable `DBT_INSTALL_DIR` to the desired installation path after the `dbt-workarea-env` command described below, but before the `dbt-build.sh` command. 

Now, do the following:
```sh
dbt-workarea-env  # If you haven't already run this
dbt-build.sh --install
```
...and this will build `listrev` in the local `./build` subdirectory and then install it as a package either in the local `./install` subdirectory or in whatever you pointed `DBT_INSTALL_DIR` to. 

Since the `dunedaq-v2.6.0` release, `dbt-create.sh` has supported not only frozen releases but the use of nightly built releases as well. Add `-n` to the `dbt-create.sh` command above to use nightly releases, e.g. ` dbt-create.sh -n N21-05-13 <your work area subdirectory>`. Pass `-l` to `dbt-create.sh` in order to list all available frozen releases, and `-l -n` to list all available nightly releases.


### Working with more repos

To work with more repos, add them to the `./sourcecode` subdirectory as we did with listrev. Be aware, though: if you're developing a new repo which itself depends on another new repo, daq-buildtools may not already know about this dependency. "New" in this context means "not listed in `/cvmfs/dunedaq.opensciencegrid.org/releases/dunedaq-v2.6.0/dbt-build-order.cmake`". If this is the case, you have one of two options:


* (Recommended) Add the names of your new packages to the `build_order` list found in `./sourcecode/dbt-build-order.cmake`, placing them in the list in the relative order in which you want them to be built. 

* First clone, build and install your new base repo, and THEN clone, build and install your other new repo which depends on your new base repo. 

Once you've added your repos and built them, you'll want to run `dbt-workarea-env --refresh` so the environment picks up their applications, libraries, etc. 

### Useful build options

`dbt-build.sh` will by default skip CMake's config+generate stages and go straight to the build stage _unless_ either the `CMakeCache.txt` file isn't found in `./build` or you've just added a new repo to `./sourcecode`. If you want to remove all the contents of `./build` and run config+generate+build, all you need to do is add the `--clean` option, i.e.
```
dbt-build.sh --clean --install
```
And if, after the build, you want to run the unit tests, just add the `--unittest` option. Note that it can be used with or without `--clean`, so, e.g.:
```
dbt-build.sh --clean --install --unittest  # Blow away the contents of ./build, run config+generate+build, and then run the unit tests
```
..where in the above case, you blow away the contents of `./build`,  run config+generate+build, install the result in `./install` and then run the unit tests. Be aware that for many packages, unit tests will only (fully) work if you've also rerun `dbt-workarea-env` with the argument `--refresh` added. 

To check for deviations from the coding rules described in the [DUNE C++ Style Guide](https://dune-daq-sw.readthedocs.io/en/latest/packages/styleguide/), run with the `--lint` option:
```
dbt-build.sh --lint
```
...though be aware that some guideline violations (e.g., having a function which tries to do unrelated things) can't be picked up by the automated linter. Also note that you can use `dbt-clang-format.sh` in order to automatically fix whitespace issues in your code; type it at the command line without arguments to learn how to use it. 

Note that unlike the other options to `dbt-build.sh`, `--lint` and `--unittest` are both capable of taking an optional argument, which is the name of a specific repo in your work area which you'd like to either lint or run unit tests for. This can be useful if you're focusing on developing one of several repos in your work area. It should appear after an equals sign, e.g., `dbt-build.sh --lint=<repo you're working on>`.

If you want to see verbose output from the compiler, all you need to do is add the `--cpp-verbose` option:
```
dbt-build.sh --cpp-verbose 
```

If you want to change cmake message log level, you can use the `--cmake-msg-lvl` option:
```
dbt-build.sh --cmake-msg-lvl=<ERROR|WARNING|NOTICE|STATUS|VERBOSE|DEBUG|TRACE>
```

You can see all the options listed if you run the script with the `--help` command, i.e.
```
dbt-build.sh --help
```
Finally, note that both the output of your builds and your unit tests are logged to files in the `./log` subdirectory. These files will have ASCII color codes which make them difficult to read with some tools; `less -R <logfilename>`, however, will display the colors and not the codes themselves. 

</details>

## Running

In order to access the applications, libraries and plugins built in your `./build` area during the above procedure, the system needs to be instructed on where to look for them. All you need to do is the following:
```
dbt-workarea-env
```

Note that if you add a new repo to your work area, after building your new code - and hence putting its output in `./build` - you'll need to run `dbt-workarea-env --refresh`.

Once the runtime environment is set, just run the application you need. listrev, however, has no applications; it's just a set of DAQ module plugins which get added to CET_PLUGIN_PATH.  

We're now going to go through a demo in which we'll use a DAQ module from listrev called RandomDataListGenerator to generate vectors of random numbers and then reverse them with listrev's ListReverser module.  

One of the packages that's part of the standard DUNE DAQ package suite which gets set up when you run `dbt-workarea-env` is cmdlib. This package comes with a basic implementation that is capable of sending available command objects from a pre-loaded file, by typing their command IDs to standard input. This command facility is useful for local, test oriented use-cases. In the same runtime area, launch the application like this:
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

For a more realistic use-case where you can send commands to the application from other services and applications, the [restcmd](https://dune-daq-sw.readthedocs.io/en/latest/packages/restcmd/) package provides a command handling implementation through HTTP. To use this plugin, we call `daq_application` in the following manner:
```sh
daq_application -n <some name for the application instance> --commandFacility rest://localhost:12345
```
To control it, let's open up a second terminal, set up the daq-buildtools environment as described at the top of this document, and start sending daq_application commands:
```sh
cd MyTopDir
dbt-workarea-env
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

<a name="adding_extra_ups_products"></a>
## Adding extra UPS products and product pools

Sometimes it is necessary to tweak the baseline list of UPS products or even UPS product pools to add extra dependencies; skip ahead to the next section if you don't need to worry about this. Adding extra dependencies can be easily done by editing the `dbt-settings` file copied over from daq-buildtools by `dbt-create.sh` and adding the new entries to `dune_products_dirs`  and `dune_daqpackages` as needed. See `/example/of/additional/user/declared/product/pool` and `package_declared_by_user v1_2_3 e19:prof` in the example of an edited `dbt-settings` file, below. Please note that package versions in your `dbt-settings` file may be different than those in this example since what you see below is simply a snapshot used for educational reasons:

```bash
dune_products_dirs=(
    "/cvmfs/dunedaq.opensciencegrid.org/releases/dunedaq-v2.5.0/externals"
    "/cvmfs/dunedaq.opensciencegrid.org/releases/dunedaq-v2.5.0/packages"
    "/example/of/additional/user/declared/product/pool" 
    #"/cvmfs/dunedaq.opensciencegrid.org/products" 
    #"/cvmfs/dunedaq-development.opensciencegrid.org/products" 
)

dune_systems=(
    "gcc               v8_2_0"
    "python            v3_8_3b"
    )

    dune_devtools=(
    "cmake             v3_17_2"
    "gdb               v9_2"
    "ninja             v1_10_0"
    )

    dune_externals=(
    "cetlib            v3_11_01     e19:prof"
    "TRACE             v3_16_02"
    "folly             v2020_05_25a e19:prof"
    "nlohmann_json     v3_9_0c      e19:prof"
    "pistache          v2020_10_07  e19:prof"
    "highfive          v2_2_2b      e19:prof"
    "zmq               v4_3_1c      e19:prof"
    "cppzmq            v4_3_0       e19:prof"
    "msgpack_c         v3_3_0       e19:prof"
    "felix             v1_1_1       e19:prof"
    "pybind11          v2_6_2       e19:prof"
    "uhal              v2_8_0       e19:prof"
    )

    dune_daqpackages=(
    "daq_cmake         v1_3_3       e19:prof"
    "ers               v1_1_2       e19:prof"
    "logging           v1_0_1b      e19:prof"
    "cmdlib            v1_1_2       e19:prof"
    "restcmd           v1_1_2       e19:prof"
    "opmonlib          v1_1_0       e19:prof"
    "rcif              v1_0_1b      e19:prof"
    "appfwk            v2_2_2       e19:prof"
    "listrev           v2_1_1b      e19:prof"
    "serialization     v1_1_0       e19:prof"
    "flxlibs           v1_0_0       e19:prof"
    "dataformats       v2_0_0       e19:prof"
    "dfmessages        v2_0_0       e19:prof"
    "dfmodules         v2_0_2       e19:prof"
    "trigemu           v2_1_0       e19:prof"
    "readout           v1_2_0       e19:prof"
    "minidaqapp        v2_1_1       e19:prof"
    "ipm               v2_0_1       e19:prof"
    "timing            v5_3_0       e19:prof"
    "timinglibs        v1_0_0       e19:prof"
    "influxopmon       v1_0_1       e19:prof"
    "nwqueueadapters   v1_2_0       e19:prof"
    "package_declared_by_user v1_2_3 e19:prof"
    )
```
As the names suggest, `dune_products_dirs` contains the list of UPS product pools and `dune_daqpackages` contains a list of UPS products sourced when you first run `dbt-workarea-env` (described below). If you've already run `dbt-workarea-env` before editing the `dbt-settings` file, you'll need to run `dbt-workarea-env --refresh` to force a reload.

&#x1F534; Hint 💡 `dbt-workarea-env` now has a new option `-s/--subset <externals, daqpackages, systems, devtools>` which allows user to set up a subset of UPS products listed in `dbt-settings`.

## Next Step


* You can learn how to create a new package by taking a look at the [daq-cmake documentation](https://dune-daq-sw.readthedocs.io/en/latest/packages/daq-cmake/)


-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: John Freeman_

_Date: Fri Jun 11 11:42:41 2021 -0500_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/daq-buildtools/issues](https://github.com/DUNE-DAQ/daq-buildtools/issues)_
</font>
