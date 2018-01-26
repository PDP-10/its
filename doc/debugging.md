# DDT debugging newbie guide

Notes where exec DDT differs from timesharing DDT.

| Command | Timesharing DDT | Exec DDT
| --- | --- | ---
| *file*^K | Start program without symbols loaded | N/A
| ^Z | Suspend program | N/A
| $P | Continue
| $^K | Load symbols | N/A
| *name*$J | Create job named *name* | N/A
| $L *file* | Load *file* into current job, including symbols | N/A
| $^X. | Kill current job | N/A
| $G | Run program from start
| $0G | Set PC to starting address | N/A
| *n*$B | Set breakpoint at *n*
| $B | Remove breakpoint at current location | Remove all breakpoints
| .$B | Set breakpoint at current location
| . | Current location
| $Q | Last printed quantity
| *n*/ | Open location *n* symbolically
| / | Open $Q
| ^J | Open next location
| ^ | Open previous location
| *n*[ | Open location *n* numerically
| = | Print $Q numerically
| _ | Print $Q as a symbol
| ' | Print $Q as six SIXBIT characters
| " | Print $Q as five ASCII characters
| # | Print $Q as one ASCII character | N/A
| ^N | Single step | N/A
| $^N | Stop at next instruction | N/A
