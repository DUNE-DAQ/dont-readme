# Local driver
## What is the "local" driver?
In order to ensure absolute consistency with the software externals, the DUNE readout external packages from the ATLAS FELIX Software Suite are built in-house and deployed as external products. Hence the reason, the driver being a foundation that connects firmware with software, it is also part of this product.

## How to build and start it
With `sudo` rights or as `root` one needs to do the following steps:
```
mkdir /opt/felix
cp -r /cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products/felix/v1_1_1 /opt/felix/
cd /opt/felix/Linux64bit+3.10-2.17-e19-prof/drivers_rcc/src/
make -j
cd ../script
sed -i 's/gfpbpa_size=4096/gfpbpa_size=8192/g' ./drivers_flx_local
./drivers_flx_local start
```

This step will be automated in the future.


-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: Roland Sipos_

_Date: Wed May 26 10:18:55 2021 +0200_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/flxlibs/issues](https://github.com/DUNE-DAQ/flxlibs/issues)_
</font>
