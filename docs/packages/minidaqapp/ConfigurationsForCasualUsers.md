# ConfigurationsForCasualUsers
The intention of this page is to provide a few simple configurations that new or casual users can use in order to test the operation of a small MiniDAQ system that uses emulators instead of real electronics.

After you have successfully followed the steps described in [Instructions for casual or first-time users](InstructionsForCasualUsers.md), we will focus now on a few variations to the default configuration used in those instructions.

After you have setup the environment and downloaded the fake input data file 


1. `cd <work_dir>`


2. `source /cvmfs/dunedaq.opensciencegrid.org/setup_dunedaq.sh`


3. `setup_dbt dunedaq-v2.6.0`


4. `dbt-workarea-env`


5. download a raw data file, either by running 
   "`curl -o frames.bin -O https://cernbox.cern.ch/index.php/s/VAqNtn7bwuQtff3/download`"
   or clicking on the [CERNBox link](https://cernbox.cern.ch/index.php/s/VAqNtn7bwuQtff3/download)) and put it into `<work_dir>`


Now we generate some sample system configurations and use _[nanorc](https://dune-daq-sw.readthedocs.io/en/latest/packages/nanorc/)_ to run MiniDaq app with them.
The tools to generate these configurations consist of a single Python script that generates MiniDAQ system configurations with different characteristics based on command-line parameters that are given to the script. This script is minidaqapp/python/minidaqapp/nanorc/mdapp_multiru_gen.py. 
The config_gen files under `python/minidaqapp/nanorc` directory were developed to work with _nanorc_ package, which itself can be seen as a basic Finite State Machine that sends commands and drives the MiniDaq app.

The created configurations will be called `mdapp_fake` and there will be a `mdapp_fake` directory created containing the produced configuration to be used with  _nanorc_.
The configurations can be run interactively with `nanorc mdapp_fake` from the <work_dir>.

1) In order to get the full set of configuration options and their `help` , run :  
`python -m minidaqapp.nanorc.mdapp_multiru_gen -h`

2) default system configuration using input data file containing data frames to be replayed by fake cards, as downloaded above use option `-d ./frames.bin`,  and the output will be in the current directory `-o .` , run:

`python -m minidaqapp.nanorc.mdapp_multiru_gen -d ./frames.bin -o .  mdapp_fake`


3) The default trigger rate generated is of 1 Hz per readout unit (ru). This can be changed with the option `-t INTEGER`, for example run:

`python -m minidaqapp.nanorc.mdapp_multiru_gen -d ./frames.bin -o . -t 2  mdapp_fake`

4) Use option `-s INTEGER` to slow down the generated data rate by a factor of INTEGER, for example run:

`python -m minidaqapp.nanorc.mdapp_multiru_gen -d ./frames.bin -o . -s 10  mdapp_fake`


5) Use option `-r FLOAT` to specify the run number, for example with run 111 :

`python -m minidaqapp.nanorc.mdapp_multiru_gen -d ./frames.bin -o . -r 111  mdapp_fake`


6) Use option `-n INTEGER` to specify the number of data producers (links) per ru (<10) or total, for example run :

`python -m minidaqapp.nanorc.mdapp_multiru_gen -d ./frames.bin -o . -n 4 mdapp_fake`


7) Use options `--host-df TEXT` , `--host-ru TEXT` , `--host-trigger TEXT` , `--host-hsi TEXT`  to specify different hosts for the different applications (processes):
`host Data-Flow (host-df)` 
`host Readout Unit (host-ru)` this is a repeatable option adding an additional ru process each time
`host Trigger app  (host-trigger)`
`host HSI app (--host-hsi)`

for example using the following fake IP addresses for the different hosts :  127.0.0.1 , 127.0.0.2 , 127.0.0.3 , 127.0.0.4

`python -m minidaqapp.nanorc.mdapp_multiru_gen -d ./frames.bin -o . --host-df 127.0.0.1 --host-ru 127.0.0.2 --host-trigger 127.0.0.3 --host-hsi 127.0.0.4  mdapp_fake`

the default for all the host options will be `localhost`

8) Running _nanorc_ can be done in interactively or in batch mode, for the later you can specify a sequence of commands to drive MiniDaq app, for example run :

 `nanorc mdapp_fake boot init conf start 102 wait 2 resume wait 60 pause wait 2 stop scrap terminate`

Where the `start <run_number>` command overrides the run_number value to be used. 
Any meaningful combination of commands is allowed. Note that the triggers will be issue only after the `resume` command is sent. 


9) examine the contents of the HDf5 file with commands like the following:
    * `h5dump-shared -H -A swtest_run000101_0000_*.hdf5`
    * and
    * `python3 $DFMODULES_FQ_DIR/dfmodules/bin/hdf5dump/hdf5_dump.py -p both -f swtest_run000101_0000_*.hdf5`


-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: Carlos Chavez Barajas_

_Date: Sat Jun 12 05:41:55 2021 +0100_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/minidaqapp/issues](https://github.com/DUNE-DAQ/minidaqapp/issues)_
</font>
