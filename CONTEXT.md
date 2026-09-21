# MAXWELL

A compression engine that emits files existing decoders already understand, smaller than the
tools that normally produce them. It starts gzip-compatible and climbs toward a modern
entropy-coded format.

## Language

### The project

**MAXWELL**:
The project. Named for Maxwell's demon — the thought experiment about extracting order from
disorder, which is what an entropy coder does.
_Avoid_: my_gzip (that is the compatibility symlink, not the project)

**maxwell**:
The binary. Dispatches on `argv[0]`, so a `my_gzip` symlink gives drop-in gzip behaviour.

**Oracle**:
The reference implementation a result is checked against — `zlib` vendored through `zig cc`, or
the system `gzip`. Correctness is defined as agreement with the oracle, never as self-consistency.
_Avoid_: reference (ambiguous — the *spec* is also a reference)

**Corpus**:
A published, fixed collection of test files used to measure ratio and throughput. Canterbury for
routine runs, Silesia for anything claimed publicly.
_Avoid_: test data, dataset, samples

### Formats and operations

**DEFLATE**:
The compressed data format of RFC 1951. Always capitalised when naming the format.

**gzip**:
The container of RFC 1952 that wraps a DEFLATE stream with a header, CRC32 and original size.
Distinct from **zlib**, the different and smaller container of RFC 1950.

**inflate**:
To decompress. The decoder inflates.
_Avoid_: decode, uncompress, extract

**deflate** (lowercase):
To compress. The encoder deflates. Lowercase distinguishes the *act* from **DEFLATE** the format.
_Avoid_: encode, compress, zip

**Block**:
The unit a DEFLATE stream is divided into, each independently typed as stored, fixed-Huffman or
dynamic-Huffman. Not a fixed size, and not aligned to anything.

### Inside the stream

**Literal**:
A byte emitted directly into the output because no useful match was found for it.

**Match**:
A run of bytes reproduced by copying from earlier output rather than storing them again.
_Avoid_: back-reference, copy, repeat

**Distance**:
How far back a match starts, in bytes, within the DEFLATE **window**. The zstd format calls the
same idea an **offset**, and keeps a history of recent ones — keep the two words apart, they are
not interchangeable across formats.

**Window**:
The span of recently emitted output a match may reach back into. 32 KB in DEFLATE.
_Avoid_: buffer, history, dictionary (a dictionary is a separate zstd feature)

**Sequence**:
The zstd unit combining a literal length, an offset and a match length. Has no DEFLATE
equivalent.

### Measurement

**Ratio**:
Compressed size divided by original size. **Lower is better.** Always state it this way round —
"better compression" and "higher ratio" mean opposite things and the confusion is easy.
_Avoid_: compression rate, compression percentage, savings

**Throughput**:
Bytes processed per second, always stated separately for deflating and inflating, since they
differ by an order of magnitude.
_Avoid_: speed, performance

**Optimal parsing**:
Choosing the division of input into literals and matches by global cost rather than greedily, so
the emitted stream is smaller at equal compatibility. The technique behind Zopfli.
_Avoid_: optimisation (too broad — that also covers throughput work)
