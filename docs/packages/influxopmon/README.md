# `influxopmon` - Influx DB plugin for Operational Monitoring
Influxopmon converts a JSON object into an influxdb insert statement, then inserts the statement into an influx database. It is part of the Operational Monitoring library (opmonlib) and used to colled the opmon data.

The latest tags are available at https://github.com/DUNE-DAQ/influxopmon/tags.

## Building and running :
The library's constructor takes an URI argument. The URI's syntax is the database : Application name: `influxdb://<host>:<port>/<endpoint>?db=<mydb>`. Authentication is managed using a reverse proxy, meaning that if the database should be accessed using authentication, the endpoint and port should be setfor the reverse prox

The library should be used calling the library's "publish" function with as argument a `nlohmann::json` object. More details about the implementation are available in the "Technical information" chapter.

The library output is the return statement from the CPR message and, if successfull, the insertion of the JSON content to the TSDB.

### URI example :
the influxopmon URI presents as such: `influx://188.185.88.195/write?db=db1`

Translating in the full, following URI eyample:

```
daq_application -c rest://localhost:12345 --name yourchoosenname -i influx://188.185.88.195/write?db=db1 
```

### Step-by-step :


1. In a build environment clone the latest influxopmon tag from DUNE-DAQ


2. Verify your environment includes the opmonlib module


3. Compile your environment


4. In a runtime environment, run the call URI

## Technical informations
### Classes
#### influxOpmonService
the class inherits `dunedaq::opmonlib::OpmonService`
##### `explicit influxOpmonService`
The constructor takes as parameter the URI described in the "Building and running" chapter and initializes variables containing the address and database where the queries should be sent, the delimiter tag and 0..N influx db tags. The delimiter tag is the keyword in a json file delimiting and describing data entries, for a Time Series Database (TSDB), it is the time tag. A TSDB typically has 0..N data tags describing the specificities of a certain data entry, such as its position or a captor identifier.

##### `public publish`
The publish function is called on data collection by the opmonlib. It calls setInsertsVector, getInsertsVector, transforms the vector returned by getInsertsVector into individual queries lines and calls the executionCommand.

##### `private executionCommand`
Takes as parameters the url to which the message should be sent and the command to be sent.
Uses cpr::Post and awaits cpr::Response.

To debug the application, print the cpr::Response response.

#### `JsonConverter`
##### `public setInsertsVector/getInsertsVector`

Handles the conversion by calling jsonToInfluxFunction and conversion errors has the following parameters:

Param 1 bool : if true, the tags are not added to the query.
Param 2 vector : is a vector of key-words delimiting tags
Param 3 string : is the keyword delimiting the timestamp
Param 4 string : is a string formatted flattened json object

setInsertsVector Void and sets sets insertsVector, insertsVector can be accessed using getInsertsVector.

##### `private jsonToInfluxFunction`
Converts a flattened json into a vector of inserts according to a delimiter passed in parameter. Calls checkDataType and convertTimeToNS

##### `private convertTimeToNS`
Influxopmon changes, if necessary, UNIX EPOCH time format to UNIX EPOCH time format in nanoseconds, to adapt to influx db the format put in parameter.
##### `private checkDataType`
Puts the correct influx parameter delimiter according to the data type of an entry, for example using ' " ' for string delimitation.

### Authentication
For security and information disclosure reasons, influxopmon, does not handle database authentication. The authentication is instead handled by an nginx instance is installed on a CERN openstack centos7 server.

#### Configuration
the redirection is handled at the server's / as following.
```
location / {
	proxy_pass https://dbod-testinfluxyd.cern.ch:8095/write;
	proxy_set_header Authorization "Token username:password";
}
```
#### Logs
Nginx redirection logs is available at 188.185.88.195/var/log/nginx/access.log 

Access to the server can be requested in necessary to Yann Donon (yann.donon@cern.ch).

## Notes :
The database is queried using [CPR](https://github.com/whoshuu/cpr "CPR"), which is a [libcurl](https://curl.se/libcurl/ "libcurl") wrapper.

In DUNE DAQ build order, "influxopmon" should be built after "opmonlib".

Influxopmon finds the following packages:  daq-cmake, opmonlib, CPR, libcurl

For any further information, contact Yann Donon (yann.donon@cern.ch).


-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: Alessandro Thea_

_Date: Wed Jun 2 13:32:51 2021 +0200_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/influxopmon/issues](https://github.com/DUNE-DAQ/influxopmon/issues)_
</font>
