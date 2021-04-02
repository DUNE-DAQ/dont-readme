# opmonlib README
# opmonlib - Operational Monitoring library

### Desctription


*opmonlib* allows applications to collect and publish operational monitoring data.
The package contains two basic output plugins, to stdout or to file.
The behavior of the output is controlled via the URI that is passed to the InfoManager constructor.
For the two plugins privided within opmonlib the following URI can be used:
- stdout://flat
outputs one line for each variable
- stdout://formatted
outputs formatted json objects
- stdout://compact
outputs a json object in one line

### Building and running examples:

