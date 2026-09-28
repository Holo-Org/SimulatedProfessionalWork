# MAXWELL

A tool that shows web developers the exact compressed cost of every source in their
gzip-compressed bundle, and then makes that bundle smaller without changing anything a decoder
needs. Its engine is a DEFLATE codec.

## Language

### The project

**MAXWELL**:
The project. Named for Maxwell's demon — the thought experiment about extracting order from
disorder, which is what an entropy coder does.
_Avoid_: my_gzig (that is the compatibility symlink, not the project)

**maxwell**:
The binary. Dispatches on `argv[0]`, so a `my_gzig` symlink gives drop-in gzip behaviour.

**Oracle**:
The reference implementation a result is checked against — zlib, or the system `gzip`.
Correctness is defined as agreement with the oracle, never as self-consistency.
_Avoid_: reference (ambiguous — the *spec* is also a reference)

**Corpus**:
A published, fixed collection of test files used to measure ratio and throughput. Canterbury for
routine runs, Silesia for anything claimed publicly.
_Avoid_: test data, dataset, samples

### What MAXWELL tells its user

**Bundle**:
The single JavaScript file a web developer ships, assembled by a bundler from many sources.
_Avoid_: build output, artifact

**Source**:
An original file listed in a bundle's source map — what the developer actually wrote.
_Avoid_: module (it collides with the modules of whatever language MAXWELL is written in), file

**Source map**:
The file, specified by ECMA-426, that maps every position in a bundle back to the source it came
from.

**Attribution**:
Assigning every compressed bit to the output byte it produced, and through the source map to the
source that byte came from. A literal's bits belong to its one byte; a match's bits are shared
across every byte it copies.

**Cost**:
The number of compressed bits attributed to something — a byte, a region, or a source. Always
compressed bits, never raw size, and always the *gzip* cost: a site serving another encoding pays a
different one.
_Avoid_: size, weight

**Report**:
What MAXWELL shows its user about a bundle: the cost of each source, either in the terminal or as
one self-contained HTML page.
_Avoid_: analysis, output, dashboard

### Formats and operations

**DEFLATE**:
The compressed data format of RFC 1951. Always capitalised when naming the format.

**gzip**:
The container of RFC 1952 that wraps a DEFLATE stream with a header, CRC32 and original size.
Distinct from **zlib**, the different and smaller container of RFC 1950.

**inflate**:
To decompress. The decoder inflates. This is the word for the codec and the design documents; the
command a user types is `decompress`, because the command line speaks its user's language.
_Avoid_: decode, uncompress, extract

**deflate** (lowercase):
To compress. The encoder deflates. Lowercase distinguishes the *act* from **DEFLATE** the format.
This is the word for the codec and the design documents; the command a user types is `compress`.
_Avoid_: encode, zip — and *compress*, except as that command

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
