# Iceberg
## Find the big directories lurking on your disk

### Introduction

For introduction and usage instructions, see the [Iceberg page](http://cgrayson.github.com/iceberg/).

### Issues

* Windows compatibility - There is none, currently. Maybe this would work under cygwin, but I
haven't tried that yet.
* HTML generation speed - I've tried to make this fast, and it's come a long way from my first
brute-force approach. But it can still take a long time on a filesystem with lots of subdirectories.
(Note that especially large files or directories are no problem; it's the number of directories
that matters.) For example, generating the 17MB report for my laptop's home directory takes
about 10 minutes.
* HTML processing speed - I've tried to make the JavaScript controls fast, too. But for large
report files, the rendering and processing may be slow. For example, that 17MB report for my
laptop's home directory takes about 8 seconds to load.