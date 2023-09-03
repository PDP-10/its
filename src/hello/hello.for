C     Fortran hello world.
C
C Compile the source code with the F40 compiler:
C *:dec sys:f40
C *hello=hello.for
C
C Then load and link the relcatable file:
C *:dec sys:loader
C *hello/g
C
C Finally start DECUUO to dump an executable:
C *45$g
C Command: dump
C *:pdump ts hello

C       Unit 5 is the user teletype.
        WRITE(5,10)
10      FORMAT(12H HELLO WORLD)
        STOP
        END
