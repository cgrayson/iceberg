# iceberg
## Find the big directories lurking on your disk

### Introduction

Iceberg is an updated incarnation of an amazingly useful tool, originally written in Java, that
 makes it easy to find the big directories that are wasting space on your disks.

This version has two parts: a bash script that generates an interactive HTML disk report, and the
JavaScript and CSS that give it its interactivity. Bootstrap and jQuery are also used, but are
loaded from CDNs and so aren't included here.

This functionality has proved useful again and again, not only on my Mac laptop, but also on the
various Linux machines I work with. That's why the HTML generation is done by a bash script, it
seemed like a good choice for lowest-common denominator in those *nix environments. Usage on
remote servers, which you may or may not have a GUI for, is also the reason for splitting the
report-generation part from the report-viewing part. Generate the HTML on your remote machine,
download it to your local PC, and pop it open in the browser of your choice.

### Usage

1. Invoke the bash script, specifying HTML output and the directory to report on, saving the
output to a file:

    `iceberg.sh --html ~/Movies > iceberg_movies.html`
    
2. Open the HTML file in your browser (after downloading it to your PC if necessary).
3. By default, directories that are 1GB or larger are highlighted in red. To change that threshold,
click a size button at the top of the window.
4. Click on folder/directory buttons to expand them and see their subdirectories. Directories
with no subdirectories cannot be expanded (those buttons are deactivated).
5. Find those directories with old backups, unneeded downloads, etc. that are wasting your disk space,
and go clean them up.
6. Repeat as desired. Remember, the HTML report is a static file. If you add or delete files,
you'll need to re-run the bash script, and refresh your browser.

![ScreenShot](https://raw.github.com/cgrayson/iceberg/master/doc/screenshot.jpg)

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