# Using fdaq
`fdaq` is a low level tool which will check the data being received by the FELIX either along the fibres or directly from the emulators. To monitor data incoming from the fibres:

```
fdaq -d <device number, 0 or 1> -t <time to run for in seconds>
```

and you should receive an output similar to (receive from device 0, for 5s):

```
==> JUMBO version
Consume FLX-device data while checking the data (blockheader and trailers),
counts errors including chunk truncation, halts when the memory buffer is near overflowing.
Also counts chunk CRC errors.
Opened FLX-device 0, firmw FLX712-FM-12chan-1910282359-GIT:dune/v1./1, trailer=32bit block=4K, buffer=1024MB

**START** using DMA #0 polling
  Secs | Recvd[MB/s] | File[MB/s] | Total[(M)B] | Rec[(M)B] | Buf[%] | Wraps
-------|-------------|------------|-------------|-----------|--------|-------
     1           1.9          0.0           1.9           0        0       0
     2           1.9          0.0           3.8           0        0       0
     3           1.9          0.0           5.7           0        0       0
     4           1.9          0.0           7.5           0        0       0
     5           1.9          0.0           9.4           0        0       0

**STOP**
-> Data checked: Blocks 4597, Errors: header=0 trailer=0
Exiting..
```

So this is an output for data playing from the ZCU102 on an infinite loop, you should see no data streaming through if no data is playing along the fibre. If  all links are enabled i.e. not just the ones connected to the fibres, then you may see some errors. This is because some links when unused produce noise (random data) so as long these links have a data source or are not enabled, you should see no errors. Otherwise any errors are likely attributed to the input data being incorrectly formatted.

To receive data from the emulator add the `-e`option:

```
fdaq -d <device number, 0 or 1> -t <time to run for in seconds> -e
```

which will monitor data generated by the emulator and you will get a similar output (the received MB/s will differ).

---

Given you don't run for too long you can dump the received data into a binary file:

```
fdaq -d <device number, 0 or 1> -t <time to run for in seconds> <binary file or dat file, specify with .bin or .dat>
```

```
fdaq -d <device number, 0 or 1> -t <time to run for in seconds> -e <binary file or dat file, specify with .bin or .dat>
```

So an example would be:

```
fdaq -d 0 -t 10 dump.bin
```

where fdaq will run with a similar output, but it will not flag up any errors so if you want to validate the setup, run `fdaq` without dumping data first. You can then read this binary file into hexadecimal format in your desired way (`hexdump` to read to terminal) and compare this dumped data to your input (will require some formatting).

---

When an error occurs, you will see messages after each second specifying the type of error and occurrences. `fdaq` will also print the first block of data with an error. An output with errors will look like (not showing the 1st data chunk)

```
==> JUMBO version
Consume FLX-device data while checking the data (blockheader and trailers),
counts errors including chunk truncation, halts when the memory buffer is near overflowing.
Also counts chunk CRC errors.
Opened FLX-device 0, firmw FLX712-FM-12chan-2011131129-GIT:rm-5.0/1070, trailer=32bit block=4K, buffer=1024MB

**START** using DMA #0 polling
  Secs | Recvd[MB/s] | File[MB/s] | Total[(M)B] | Rec[(M)B] | Buf[%] | Wraps
-------|-------------|------------|-------------|-----------|--------|-------
     1           1.9          0.0           1.9           0        0       0
   ### Blocks 454 Errors: header=0 trailer=54 (trunc=53,err=1,length=0,type=0), crc=0
     2           1.9          0.0           3.8           0        0       0
   ### Blocks 917 Errors: header=0 trailer=204 (trunc=203,err=1,length=0,type=0), crc=0
     3           1.9          0.0           5.6           0        0       0
   ### Blocks 1371 Errors: header=0 trailer=332 (trunc=331,err=1,length=0,type=0), crc=0
     4           1.9          0.0           7.5           0        0       0
   ### Blocks 1834 Errors: header=0 trailer=402 (trunc=401,err=1,length=0,type=0), crc=0
     5           1.9          0.0           9.4           0        0       0
   ### Blocks 2288 Errors: header=0 trailer=441 (trunc=440,err=1,length=0,type=0), crc=0
     6           1.9          0.0          11.3           0        0       0
   ### Blocks 2753 Errors: header=0 trailer=549 (trunc=548,err=1,length=0,type=0), crc=0
     7           1.9          0.0          13.2           0        0       0
   ### Blocks 3207 Errors: header=0 trailer=708 (trunc=707,err=1,length=0,type=0), crc=0
     8           1.9          0.0          15.1           0        0       0
   ### Blocks 3669 Errors: header=0 trailer=799 (trunc=798,err=1,length=0,type=0), crc=0
     9           1.9          0.0          16.9           0        0       0
   ### Blocks 4133 Errors: header=0 trailer=850 (trunc=849,err=1,length=0,type=0), crc=0
    10           1.9          0.0          18.8           0        0       0
   ### Blocks 4586 Errors: header=0 trailer=911 (trunc=910,err=1,length=0,type=0), crc=0

**STOP**
-> Data checked: Blocks 4586, Errors: header=0 trailer=911, ErrorI 4092
```

-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: roland-sipos_

_Date: Wed May 26 09:36:13 2021 +0200_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/flxlibs/issues](https://github.com/DUNE-DAQ/flxlibs/issues)_
</font>
