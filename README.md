# Iceberg
## Find the big directories lurking under the surface of your disk

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

### Implementation

If you dig into the bash script, you'll see that all it basically does is translate output from the
Unix command `du` into HTML. `du` is fast; translating that text output is the slower part by far.
For the 110k directories under my laptop's home directory, `du` by itself takes about 40 seconds, while
the other 9+ minutes is cranking out the HTML.

### Other Generators

Want to make this thing faster? Want to make it work on more platforms (*cough* Windows *cough*)?
Handy with Perl, PHP, Ruby, C, etc.? Give it a shot, let me know, and I'll gladly include it here. For
the JavaScript and CSS to work, you'll just need to follow this structure in your generated HTML, with
the whole thing wrapped in the boilerplate the bash script uses:

```html
  <div class='folder'>
    <button class='btn btn-small enabled'><i class='icon-folder-close'></i></button>
    <span class='size'>5.0G</span> Root-Level Directory
  </div>
  <div class='child'>
    <div class='folder'>
      <button class='btn btn-small disabled'><i class='icon-folder-close'></i></button>
      <span class='size'>8.0K</span> 2nd Level Directory, no subfolders
    </div>
    <div class='folder'>
      <button class='btn btn-small enabled'><i class='icon-folder-close'></i></button>
      <span class='size'>6.7M</span> Another 2nd Level Directory, with subfolders
    </div>
    <div class='child'>
      <div class='folder'>
        <button class='btn btn-small enabled'><i class='icon-folder-close'></i></button>
        <span class='size'>900K</span> 3rd Level Directory, with subfolders
      </div>

      <!-- etc. -->
    </div>
  </div>
```

In the /test directory there is `du_linux.out`, a 2,700 line file containing the `du -h`
output from a recent checkout of the Linux kernel source. There is also an Iceberg HTML
output file, [ice_linux.html](http://cgrayson.github.com/iceberg/test/ice_linux.html)
created from this (e.g., output of `iceberg.sh -d du_linux.out > ice_linux.html`),
which can be used as standard of comparison for new generators.