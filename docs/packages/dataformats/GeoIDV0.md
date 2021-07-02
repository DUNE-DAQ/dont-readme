# GeoID v0 (Deprecated)

This document describes the format of the GeoID struct, version 0 (unversioned).

# Description of GeoID

GeoID version 0 (unversioned) consists of four 16-bit words (for a total of 64 bits):



0. System Type


1. Region Number


2. Element Number (upper 16 bits)


3. Element Number (lower 16 bits)

# C++ Code for GeoID

```CPP
struct GeoID
{
  enum class SystemType : uint16_t
  {
    kTPC = 1,
    kPDS = 2,
    kDataSelection = 3,
  ...
    kInvalid = 0
  };
  SystemType system_type{ SystemType::kInvalid };
  uint16_t region_number{ std::numeric_limits<uint16_t>::max() };
  uint32_t element_number{ std::numeric_limits<uint32_t>::max() };
};
```

# Notes

GeoID does not currently have a version field. If its format changes, it would have to either be rolled into a version update of the products that use it, or have a version number added.


-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: Eric Flumerfelt_

_Date: Thu Jul 1 14:47:01 2021 -0500_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/dataformats/issues](https://github.com/DUNE-DAQ/dataformats/issues)_
</font>
