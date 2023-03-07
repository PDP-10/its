The get-its-dates tool accepts a directory of ITS files on the host, presumably extracted from an ITS tape,
and generates a list of Linux timestamps, suitable to be used by the touch program, and in the same
format as found here:  https://github.com/PDP-10/its/blob/master/build/timestamps.txt.

To build the tool, you'll need a scala build environment and SBT.  The best way to get this environment
is to install SBT following the instructions on this page: https://docs.scala-lang.org/getting-started/sbt-track/getting-started-with-scala-and-sbt-on-the-command-line.html.

Once your environment is setup, use the command: 'sbt assembly'.  The output should look like this:

$ sbt assembly
[info] welcome to sbt 1.4.4 (Ubuntu Java 11.0.18)
[info] loading settings for project get-its-dates-build from assembly.sbt,metals.sbt ...
[info] loading project definition from /mnt/its/ITS/ws/its/tools/get-its-dates/project
[info] loading settings for project get-its-dates from build.sbt ...
[info] set current project to get-its-dates (in build file:/mnt/its/ITS/ws/its/tools/get-its-dates/)
[info] compiling 2 Scala sources to /mnt/its/ITS/ws/its/tools/get-its-dates/target/scala-2.13/classes ...
[info] Including: scala-library-2.13.4.jar
[info] Checking every *.class/*.jar file's SHA-1.
[info] Merging files...
[warn] Merging 'NOTICE' with strategy 'rename'
[warn] Merging 'LICENSE' with strategy 'rename'
[warn] Merging 'META-INF/MANIFEST.MF' with strategy 'discard'
[warn] Strategy 'discard' was applied to a file
[warn] Strategy 'rename' was applied to 2 files
[info] SHA-1: d054c5f3b80a5905840f5fc3b44f2e7896d5192e
[success] Total time: 6 s, completed Mar 7, 2023, 12:56:51 PM
$

This produces an executable JAR file.  Then, invoke the JAR by running:

java -jar ./target/scala-2.13/get-its-dates-assembly-0.1.jar <directory> <prefix-to-remove>

The output will contain lines with timestamp specifications suitable for adding to build/timestamps.txt.

For example, assume you have a directory called "mudtmp" located in /path/to/stuff/mudtmp, and it contains these files
extracted from an ITS tape:

$ ls -l --full-time /path/to/stuff/mudtmp
total 20
-rw-rw-r-- 1 eswenson eswenson 14390 1983-02-08 22:00:07.000000000 -0800 added.files
-rw-rw-r-- 1 eswenson eswenson    35 1978-01-08 06:39:37.000000000 -0800 dump.bit
$

Running the tool with:

java -jar ./target/scala-2.13/get-its-dates-assembly-0.1.jar /path/to/stuff/mudtmp /path/to/stuff

Will generate

mudtmp/added.files 198302082200.07
mudtmp/dump.bit 197801080639.37



