# DDT debugging newbie guide

Notes where exec DDT differs from timesharing DDT.

| Command | Timesharing DDT | Exec DDT
| --- | --- | ---
| *file*<kbd>^K</kbd> | Start program without symbols loaded | N/A
| <kbd>^Z</kbd> | Suspend program | N/A
| ◊P | Continue
| ◊<kbd>^K</kbd> | Load symbols | N/A
| *name*◊J | Create job named *name* | N/A
| ◊L *file* | Load *file* into current job, including symbols | N/A
| ◊<kbd>^X</kbd>. | Kill current job | N/A
| ◊G | Run program from start
| ◊0G | Set PC to starting address | N/A
| *n*◊B | Set breakpoint at *n*
| ◊B | Remove breakpoint at current location | Remove all breakpoints
| .◊B | Set breakpoint at current location
| . | Current location
| ◊. | Current value of PC
| ◊Q | Last printed quantity
| *n*/ | Open location *n* symbolically (show instructions and symbols)
| / | Open ◊Q
| <kbd>^J</kbd> | Open next location
| ^ | Open previous location
| *n*[ | Open location *n* numerically
| = | Print ◊Q numerically
| _ | Print ◊Q as a symbol
| ' | Print ◊Q as six SIXBIT characters
| " | Print ◊Q as five ASCII characters
| # | Print ◊Q as one ASCII character | N/A
| <kbd>^N</kbd> | Single step | N/A
| ◊<kbd>^N</kbd> | Stop at next instruction (skip over calls) | N/A
