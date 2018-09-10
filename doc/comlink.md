# How to use com links in ITS

Com links allow terminal sharing between users.

### Entering and exiting com link mode

Use <code><kbd>^_</kbd>C*foo*</code> to attach to terminal or user
*foo*.  An octal number specifies a terminal number.  This works with
any number of users.

Initially, input and output to programs is disabled, so users can type
text to each other.

Use <code><kbd>^_</kbd>N</code> to detach from terminal sharing.


### Using programs in com link mode

In com link mode, toggle program I/O with <code><kbd>^\_</kbd>I</code>
and <code><kbd>^_</kbd>O</code>.  When I/O is enabled, programs can
use the terminal normally.


### Slaving terminals

Slaving a terminal means sending input to it from another terminal.
When in com link mode, use <code><kbd>^\_</kbd>S*foo*</code> to slave
another terminal.  To toggle sending it input, use
<code><kbd>^\_</kbd>E</code>.  Doing <code><kbd>^_</kbd>E</code> will
automatically slave the other terminal if there are only two terminals
in the com link session.
