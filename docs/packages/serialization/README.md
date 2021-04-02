# serialization README
# DUNE DAQ C++ object serialization utilities

This repository contains utilities for serializing/deserializing C++ objects for DUNE DAQ. Serialization allows objects to be sent across the network or persisted to disk.

You'll need to edit your `dbt-settings` file to use the `msgpack_c` UPS product. Add `"/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products_dev"` to `dune_products_dirs` and `"msgpack_c v3_3_0 e19:prof"` to `dune_products`. See https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.2.0#adding-extra-ups-products-and-product-pools for more information.

## Quick start

An appropriately-defined C++ type (see below) can be serialized/deserialized as follows:

```cpp
 MyClass m;
 m.some_member=3;
 // ... set other parts of m...
 dunedaq::serialization::SerializationType stype=dunedaq::serialization::MsgPack; // or JSON, which is human-readable but slower
 std::vector<uint8_t> bytes=dunedaq::serialization::serialize(m, stype);
 
 // ...elsewhere, after receiving the serialized object:
 MyClass m_recv=dunedaq::serialization::deserialize<MyClass>(bytes, stype);
```

If you want to send/receive the serialized object over [IPM](https://github.com/DUNE-DAQ/ipm), `NetworkObjectSender<T>` and `NetworkObjectReceiver<T>` provide a convenience wrapper:

```cpp
// Sender process:
NetworkObjectSender<FakeData> sender(sender_conf);
FakeData fd;
fd.fake_count=25;
sender.send(fd, std::chrono::milliseconds(2));
// Receiver process:
NetworkObjectReceiver<FakeData> receiver(receiver_conf);
FakeData fd_recv=receiver.recv(std::chrono::milliseconds(2));
// Now fd_recv.fake_count==25
```

See [network_object_send_receive.cxx](./test/apps/network_object_send_receive.cxx) for a full example, including setting the `sender_conf` and `receiver_conf` objects.

## Making types serializable

### With [`moo`](https://github.com/brettviren/moo)

If your type is specified via a `moo` schema, you just need to `moo render` your schema with the `onljs.hpp.j2` template (for json serialization) and with `omsgp.hpp.j2` (for MsgPack serialization; requires `moo` > 0.5.0). Then you will need to `#include` both of the generated headers wherever you serialize/deserialize objects of your type.

### Without [`moo`](https://github.com/brettviren/moo)

If your class is not specified via a `moo` schema, it can be made serializable by adding convertor functions for `nlohmann::json` and `msgpack`. (Right now, _both_ methods need to be implemented, even if you only plan to use one of them. Maybe this could be changed, but the serialization type can come from config, and might not necessarily be known at compile-time, so code for both has to be available). Full instructions for serializing arbitrary types with `nlohmann::json` are available [here](https://nlohmann.github.io/json/features/arbitrary_types/) and for `msgpack`, [here](https://github.com/msgpack/msgpack-c/wiki/v2_0_cpp_packer).

The easiest way to achieve this is with the `DUNE_DAQ_SERIALIZE()` convenience macro provided in [`Serialization.hpp`](./include/serialization/Serialization.hpp):

```cpp
// A type that's made serializable "intrusively", ie, by changing the type itself
struct MyTypeIntrusive
{
  int i;
  std::string s;
  std::vector<double> v;

  DUNE_DAQ_SERIALIZE(MyTypeIntrusive, i, s, v);
};
```

A complete example can be found in [`non_moo_type.cxx`](./test/apps/non_moo_type.cxx), including an example of how to make a class serializable "non-intrusively", ie, without changes to the class itself.

## Design notes

Choice of serialization methods: there are many, many libraries and formats for serialization/deserialization, with a range of tradeoffs. I chose `nlohmann::json` and `msgpack` to get one human-readable format, and one faster binary format. `nlohmann::json` is chosen as the library for the human-readable format since it was already being used in DUNE DAQ code. For the binary format, I wanted a library that allows serialization of arbitrary types, rather than requiring types to be specified in, eg the library's DSL (this rules out, eg, `protobuf`). We may have to revisit that requirement if we find that `msgpack` does not meet performance requirements.
