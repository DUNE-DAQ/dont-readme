# Directory structure of this repo
This repository is structured as follows:

* `cmake`

* `docs`

* `include/readout`
    * `concepts`
    * `models`
    * `utils`

* `plugins`

* `python/readout`

* `schema/readout`

* `scripts/performance`

* `src`

* `test`

* `unittest`

## Where to find the code
The main code of the readout package is located in three directories: `include/readout`, `plugins` and `src`.
While code in `include/readout` is meant to be reusable by other packages, the other two directories contain code that is specific to the far detector frontend.
The goal is to have everything in `include/readout` in a generic form such that other frontends can be implemented with it.
To do so, new frontend datatypes can be defined and the generic templated classes instantiated with them. 
The organisation of `include/readout` itself separated concepts, modules and utils.

Concepts are interfaces or abstract classes. Their implementations are models in the nomenclature of the readout.
All models in `models` inherit from a class in `concepts`, usually the names of the two classes are related.
Readout facilities use the capabilities of generic concepts and can be instantiated (through the use of templating) with models that implement them.
This makes it easy to implement new models with different properties that are necessary for different frontend types.
A good example for this is the latency buffer which buffers raw data received from the frontend and provides it to the request handler that can look up chunks based on timestamps.
The file `LatencyBufferConcept.hpp` in `include/readout/concepts` defines some properties that have to be implemented, for example access to front and back or the ability to add and remove elements.
There are several latency buffer implementations in `include/readout/models`.
The different latency buffer implementations have different requirements for different frontend types. 
One uses a binary search and requires that the chunks which are written to it are already sorted, i.e. the timestamps of chunks only increase.
The implementation can use this fact to make pushing and popping from the queue constant time operations and use a binary search to find and element for a given timestamp.
If data can come in unordered, the skip list can be used as it can insert elements in any order.
The tradeoff here is reduced performance.

When a readout unit is created, the models to use are defined and can be interchanged.
`utils` contains code that provides functionality which is not directly related or exclusive to readout applications.
The `plugins` directory contains the appfwk `DAQModule`'s for the readout.
`schema/readout` contains the jsonnet schema files used for code generation with moo.
The define structures for the configuration of the application and info structs for the operational monitoring.

## Testing
To run and test the readout in a self-contained manner (one can always use the `minidaqapp` to run a more complete DAQ), a script for generating a `daq_application` config file can be found in `python/readout`.
`test` contains configs generated with this script and some standalone test applications.
In `unittest` one can very unsurprisingly find unit tests for the readout.
Lastly, `scripts/performance` contains code and configurations to do thread pinning of the application.

-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: Florian Grötschla_

_Date: Fri Jun 11 10:43:20 2021 +0200_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/readout/issues](https://github.com/DUNE-DAQ/readout/issues)_
</font>
