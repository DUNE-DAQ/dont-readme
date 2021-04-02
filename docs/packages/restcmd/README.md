# restcmd README
## restcmd - HTTP REST backend based CommandFacility
This implementation of the CommandFacility interface from cmdlib, is providing a way to send
commands to applications via HTTP. This is carried out by the small web-server that this plugin
carries. The server answers to HTTP POST requests, where the request body is the content of the
command itself. The package ships a really lightweight Python script to send commands from the
JSON files, that is located under the scripts directory.

### Dependencies
The Pistache library is needed to build and run this plugin. At the moment, it's located under products_dev. 
The dependency is available under devevlopment products. Please pay attention to the build steps that include how to setup pistache from cvmfs.

### Building and running examples:


* create a software work area
  * see https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v1.2.1

* clone this repo into your work/development area
  * `cd <your_work_area>/sourcecode`
  * `git clone https://github.com/DUNE-DAQ/restcmd.git`
  * `cd ..`

* build the software. Along with executing the commands below, you may also want to consider adding the `export PRODUCTS...` and `setup pistache...` lines to `setup_build_environment` for future sourcings
  * `. ./setup_build_environment`
  * `export PRODUCTS=/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products_dev:$PRODUCTS`
  * `setup pistache v2020_10_07 -q e19:prof`
  * `./build_daq_software.sh --install` 

* run the demos in another shell
  * `cd <your work area>`
  * `. ./setup_runtime_environment`
  * `restcmd_test_rest_app`
    * the application will terminate in 20 seconds
    * from the first terminal, send commands via [curl](#sendcurl) or with the more preferred [send-restcmd.py](#sendcmd)

## Running DAQ applications
To select this CommandFacility implementation, use the `rest://` prefix for the application's commandFacility parameter as a URI.
The URI is parsed, and the facility will listen to POST requests on the specified interface and port. 

    daq_application --commandFacility rest://localhost:12345

## Sending commands

### <a name="sendcmd"></a> With send-restcmd
The scripts directory also contains a command sender application based on Python3 and its Requests module. It is used on the following way:

    send-recv-restcmd.py --file ./sourcecode/restcmd/test/test-init.json

The script can recognize multiple command objects in the same file, and send them one by one, with a configurable wait time between each send:

    send-recv-restcmd.py --wait 3 --file ./sourcecode/restcmd/test/fdpc-commands.json

There is also an interactive mode. This requires typing the next command's ID from the set of commands that are available in the file:

    send-recv-restcmd.py --interactive --file ./sourcecode/restcmd/test/fdpc-commands.json

To see details how to connect to different applications, have a look on the help:

    send-recv-restcmd.py --help

### <a name="sendcurl"></a> With CURL
Sending commands with `curl` makes low-level debugging easier.
Example of sending only a configuration command:

    cmdfile=sourcecode/restcmd/test/test-init.json
    curl --header "Content-Type: application/json" --header "X-Answer-Port: 12333" --request POST --data @$cmdfile http://localhost:12345/command

The command facility enforces the content type. The following will fail:

    cmdfile=sourcecode/restcmd/test/test-init.json
    curl --header "Content-Type: application/xml" --header "X-Answer-Port: 12333" --request POST --data @$cmdfile http://epdtdi103:12345/command

